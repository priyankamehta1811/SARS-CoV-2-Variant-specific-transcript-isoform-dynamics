#!/bin/bash
#SBATCH --job-name=clustalo.sh
#SBATCH --output=clustalo.out
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

#conda activate clustalo 
clustalo -i merge.fa -o aligned.fa --outfmt=fasta --threads=10 
/bin/hostname
