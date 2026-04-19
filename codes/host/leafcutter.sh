#!/bin/bash
#SBATCH --job-name=leafcutter
#SBATCH --output=leafcutter_%A_%a.out
#SBATCH --error=leafcutter_%A_%a.err
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=20
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --partition=compute

#conda activate regtools
#conda activate leafcutter

#extracting junctions
for i in *.bam; do
    echo Converting ${i} to ${i}.junc
    samtools index ${i}
    regtools junctions extract -a 8 -m 10 -M 500000 ${i} -o ${i}.junc
    echo ${i}.junc >> test_juncfiles.txt
done

#clustering introns
python /leafcutter/clustering/leafcutter_cluster_regtools.py \
    -j test_juncfiles.txt \
    -m 10 \
    -o testVOC \
    -l 500000

#Differential intron excision analysis
/leafcutter/scripts/leafcutter_ds.R \
    /leafcutter/testVOC_perind_numers.counts.gz \
    /leafcutter/group_file.txt \
    -p 8 \
    -e gencodev48exon.txt.gz

#plotting splice junctions
/leafcutter/scripts/ds_plots.R \
    -e gencodev48exon.txt.gz \
    testVOC_perind_numers.counts.gz \
    group_file.txt \
    /leafcutter_ds_cluster_significance.txt  \
    -f 0.05


/leafcutter/leafviz/prepare_results.R \
    negvspos_perind_numers.counts.gz \
    /leafcutter/PreVOC_vs_Delta/leafcutter_ds_cluster_significance.txt \
    /leafcutter/PreVOC_vs_Delta/leafcutter_ds_effect_sizes.txt \
    /leafcutter/annotation_code  \
    --meta_data_file /leafcutter/group_file.txt \
    --output /leafcutter/PreVOC_vs_Delta/PreVOC_vs_Delta_leafviz.RData \
    --code /leafcutter/PreVOC_vs_Delta/PreVOC_vs_Delta

/bin/hostname