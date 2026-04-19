#!/bin/bash
#SBATCH --job-name=salmon
#SBATCH --partition=compute
#SBATCH --ntasks-per-node=20
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --output=logs/salmon_%j.out
#SBATCH --error=logs/salmon_%j.err

# ==============================
# Salmon quasi-mapping mode
# ==============================

# Loop through each R1 fastq file
for i in *R1_paired.fastq.gz; do 
    base=$(basename ${i} _R1_paired.fastq.gz); 
    out=$(basename ${i} |sed 's/_.*//'); 

    # Run salmon
    salmon quant -i ../../../human_ref_2023/salmon_gencode_index_without_decoy/ \
    -l A \
    -1 ${i} \
    -2 ${base}_R2_paired.fastq.gz \
    -p 40 \
    --validateMappings \
    --numGibbsSamples 10 \
    --gcBias \
    -o  quants/${out} ; 
    echo "Quantification done for $base"
done

echo "Quantification done for all samples"
date

/bin/hostname
