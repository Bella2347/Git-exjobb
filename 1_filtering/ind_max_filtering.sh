#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J filter_on_individual_depth
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

python3 ../../Git-exjobb/1_filtering/ind_depth_filtering.py ../../0_data/subset_vcf/parva_unfiltered_n00001.vcf parva_depth.txt parva_n00001_maxDepth.vcf

python3 ../../Git-exjobb/1_filtering/ind_depth_filtering.py ../../0_data/subset_vcf/taiga_unfiltered_n00001.vcf taiga_depth.txt taiga_n00001_maxDepth.vcf

