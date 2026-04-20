suppressPackageStartupMessages(library(tximeta))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(fishpond))
suppressPackageStartupMessages(library(org.Hs.eg.db))
suppressPackageStartupMessages(library(SummarizedExperiment))

#=======================
#Using age as covariate
#=======================

#'*Step 1: load metadata*
metadata<-read.csv("viral VOC/Excelsheets/patient_data.csv", header=TRUE)

#Grouping age
colData(y)$age_group <- cut(
  colData(y)$age,
  breaks = c(0, 50, 100),
  labels = c("young", "old")
)  

names<-metadata$Sample
condition<-factor(metadata$Group, levels=c("PreVOC","Delta","Omicron"))
age<-metadata$Age

#importing salmon quantification
files<-file.path("quants/VOC_quant_transcript/quants/selected_quants/", metadata$Sample,"quant.sf")
coldata<-data.frame(files,names, condition, age, stringsAsFactors = FALSE)
coldata<-drop_na(coldata)
all(file.exists(coldata$files))

set.seed(4)

se <- tximeta(coldata)
assayNames(se)
head(rownames(se))

#creating y summarized experiment
y <- se
y <- y[,y$condition %in% c("PreVOC","Omicron")] 
y$condition <- factor(y$condition, levels=c("PreVOC","Omicron")) #Reference = PreVOC
y <- scaleInfReps(y)
y <- labelKeep(y)
y <- y[mcols(y)$keep,]
table(y$age_group, y$condition)
y <- swish(y, x = "condition", cov = "age_group") #age_group as covariate


#extracting results
y <- addIds(y, "SYMBOL", gene=TRUE, multiVals='list')
d<-data.frame(lapply(mcols(y), as.character), stringsAsFactors=FALSE)
write.csv(d, "swish/PreVOC_vs_Omicron_AGE_DTE.csv")
