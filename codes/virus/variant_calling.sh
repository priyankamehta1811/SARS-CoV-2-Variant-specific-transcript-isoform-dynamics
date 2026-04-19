#!/bin/bash
#SBATCH --job-name=vcf.sh
#SBATCH --output=vcf.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=15
#SBATCH --partition=compute
echo "SLURM_JOBID"=$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLUMTMPDIR"=$SLUMTMPDIR
echo "Date = $(date)"
echo "Hostname = $(hostname -s)"
echo ""
echo "Number of nodes allocated = $SLURM_JOB_NUM_NODES"
echo "Number of task salloctaed = $SLURM_NTASKS"
echo "Number of cores alloctaed = $SLURM_CPUS_PER_TASK"
echo "Working Directory = $(pwd)"
echo "working directory = $SLURM_SUBMIT_DI"


#variant calling (FreeBayes):

conda activate freebayes

for i in IGIB*; do echo ${i} ;
        freebayes -f /data/viral_ref/covid/Sars_cov_2.ASM985889v3.dna.toplevel.fa  ${i}/${i}Aligned.sorted.bam > variant_calling/${i}.vcf;
done
/bin/hostname

#vcf filtering (bcftools):
module load bcftools

for i in IGIB*; do echo ${i} ; 
bcftools filter -i 'QUAL > 30 && DP > 10' variant_calling/${i}.vcf -o ${i}/${i}filtered.vcf
done

#merge all vcfs

bgzip *.filtered.vcf
bcftools merge *.vcf.gz -o merged.vcf.gz
/bin/hostname