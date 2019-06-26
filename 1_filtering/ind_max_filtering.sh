#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J filter_on_individual_depth
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

python3 ../../Git-exjobb/1_filtering/ind_depth_filtering.py ../1_genotype_depth/parva_unfiltered_n00001.vcf depth parva_n00001_filtered.vcf
