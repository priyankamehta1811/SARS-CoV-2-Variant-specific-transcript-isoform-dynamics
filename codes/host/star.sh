#!/bin/bash
#SBATCH --job-name=star
#SBATCH --partition=compute
#SBATCH --ntasks-per-node=20
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --output=logs/star_%j.out
#SBATCH --error=logs/star_%j.err

# ===============
# STAR Alignment
# ===============

#load modules
module load star
module load samtools


# Create STAR index

STAR --runMode genomeGenerate \
    --runDirPerm All_RWX \
    --runThreadN 6 \
    --genomeDir Human_ref/ \
    --genomeFastaFiles Human_ref/GRCh38.primary_assembly.genome.fa \
    --sjdbGTFfile Human_ref/gencode.v46.primary_assembly.annotation.gtf  \
    --sjdbOverhang 150

# This will create a directory named "star_index"


#Run STAR Alignment
# Loop through each R1 fastq file

for i in *_R1_paired.fastq.gz; do 

    #create basename
    base=$(basename ${i} _R1_paired.fastq.gz); 
    
    # Run STAR 
    STAR --genomeDir /star_index/ \
    --readFilesIn $i ${base}_R2_paired.fastq.gz \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate \
    --outReadsUnmapped Fastx \
    --quantMode GeneCounts \
    --runThreadN 6 ulimit \
    -v 32131424542 \
    --outFileNamePrefix $base/ ;
    
    # Run samtools
    echo "indexing ${base}/Aligned.sortedByCoord.out.bam" ;
    samtools index ${base}/Aligned.sortedByCoord.out.bam; 
done

echo "Alignment done for all the samples"
date

/bin/hostname