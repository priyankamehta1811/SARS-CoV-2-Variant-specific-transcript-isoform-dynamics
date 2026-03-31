#!/bin/bash
#SBATCH --job-name=trimmomatic
#SBATCH --partition=compute
#SBATCH --ntasks-per-node=20
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --output=logs/trimmomatic_%j.out
#SBATCH --error=logs/trimmomatic_%j.err

# ==============================
# Trimmomatic paired-end trimming
# ==============================

# Load Java module if needed
# module load java

# Paths
TRIM_DIR="trimmomatic_output"
ADAPTERS="Trimmomatic-0.39/adapters/TruSeq3-SE.fa"
TRIMMOMATIC_JAR="Trimmomatic-0.39/trimmomatic-0.39.jar"

# Create output directories
mkdir -p $TRIM_DIR
mkdir -p logs

echo "Starting Trimmomatic trimming..."
date

# Loop through all R1 fastq files
for R1 in *_R1_001.fastq.gz; do
    # Generate base name
    BASE=$(basename "$R1" "_R1_001.fastq.gz")
    R2="${BASE}_R2_001.fastq.gz"

    echo "Trimming sample: $BASE"

    # Run Trimmomatic PE
    java -jar $TRIMMOMATIC_JAR PE \
        "$R1" "$R2" \
        "$TRIM_DIR/${BASE}_R1.trim.fastq.gz" "$TRIM_DIR/${BASE}_R1.untrim.fastq.gz" \
        "$TRIM_DIR/${BASE}_R2.trim.fastq.gz" "$TRIM_DIR/${BASE}_R2.untrim.fastq.gz" \
        SLIDINGWINDOW:4:20 MINLEN:36 ILLUMINACLIP:$ADAPTERS:2:30:10

    echo "Finished trimming $BASE"
done

echo "All samples trimmed successfully!"
date