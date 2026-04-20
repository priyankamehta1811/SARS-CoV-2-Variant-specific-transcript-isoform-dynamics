library(tximport)
library(GenomicFeatures)
library(readr)
library(DESeq2)
library(tximeta)
library(AnnotationDbi)
library(org.Hs.eg.db)
#read tx2gene conversion file
tx2gene<-read.csv("human reference/Homo_sapiens.GRCh38.111.csv",header=TRUE)

#importing salmon quantifications
samples <- read.csv("viral VOC/Excelsheets/patient_data.csv", header = TRUE)# use csv file
files <- file.path("quants/VOC_quant_transcript/quants/selected_quants", samples$Sample, "quant.sf")
names(files) <- paste0(samples$Sample)
file.exists(files)
txi.salmon <- tximport(files, type = "salmon", tx2gene = tx2gene, ignoreTxVersion=TRUE)

#=====================================
#Using >10 reads in 10 samples cutoff
#=====================================

samples$Age <- scale(samples$Age, center = TRUE, scale = TRUE)
dds <- DESeqDataSetFromTximport(txi.salmon, colData = samples, design = ~Group)

#filter lowly expressed genes
keep <- rowSums(counts(dds) >= 10)> 10
dds <- dds[keep,]
dds<-DESeq(dds)

res1 <- results(dds, contrast=c("Group","Omicron","PreVOC"))
res2 <- results(dds, contrast=c("Group","Delta","PreVOC"))
res3 <- results(dds, contrast=c("Group","Omicron","Delta"))

#========================
#Taking Age as covariate
#========================

#Convert to Deseq2 dataframe and run Deseq2
samples$Age <- scale(samples$Age, center = TRUE, scale = TRUE)
dds <- DESeqDataSetFromTximport(txi.salmon, colData = samples, design = ~Age + Group)

#filter lowly expressed genes
keep <- rowSums(counts(dds) >= 10)> 2
dds <- dds[keep,]
dds<-DESeq(dds)

#extract results
res4 <- results(dds, contrast=c("Group","Omicron","PreVOC"))
res5 <- results(dds, contrast=c("Group","Delta","PreVOC"))
res6 <- results(dds, contrast=c("Group","Omicron","Delta"))