#!/bin/bash
#SBATCH --job-name=bcl2fastq
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=6
#SBATCH --time=24:00:00
#SBATCH --output=logs/bcl2fastq_%j.out
#SBATCH --error=logs/bcl2fastq_%j.err

# ==============================
# BCL2FASTQ Conversion Script
# ==============================

# Load module (if your cluster uses modules)
# module load bcl2fastq

# Create output directories
mkdir -p logs
mkdir -p igib/fastq_files

echo "Starting bcl2fastq conversion..."
date

# ------------------------------
# Standard bulk RNA-seq conversion
# ------------------------------
bcl2fastq \
  --runfolder-dir igib/ \
  --output-dir igib/fastq_files \
  --sample-sheet igib/SampleSheet.csv \
  --no-lane-splitting \
  --minimum-trimmed-read-length=8 \
  --mask-short-adapter-reads=8 \
  -p 12

echo "Bulk RNA-seq conversion completed"
