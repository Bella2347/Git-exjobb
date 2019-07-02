#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J filter_on_individual_depth
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

python3 ../../Git-exjobb/1_filtering/ind_depth_filtering.py ../3_indels_remove/parva_chrContigs_keepBiallelic.recode.vcf parva_depth.txt parva_chrContigs_keepBiallelic_maxDepth.vcf


