#!/bin/bash
#SBATCH --job-name=rmats.sh
#SBATCH --error=rmats.err
#SBATCH --output=rmats.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --partition=compute

#conda activate rmats-turbo

#Define input and output directory
$in = /rmats
$out = /rmats/PreVOC_vs_Delta


#Run rMATs
/rmats_build/rmats-turbo/run_rmats \
    --b1 ${in}/PreVOC_paths.txt \
    --b2 ${in}/Delta_paths.txt \
    --gtf /Human_ref/gencode.v46.primary_assembly.annotation.gtf \
    --libType fr-firststrand \
    --novelSS \
    -t paired \
    --anchorLength 6 \
    --readLength 150 \
    --variable-read-length  \
    --nthread 20  \
    --od ${out}/output \
    --tmp ${out}/tmp_output

/bin/hostname