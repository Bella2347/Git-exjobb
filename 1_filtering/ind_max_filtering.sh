#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 10:00:00
#SBATCH -J filter_on_individual_depth
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

python3 ../Git-exjobb/1_filtering/ind_depth_filtering.py ../0_data/allGQ30_chrMappingScaffolds.vcf allGQ30_chrMappingScaffolds_genoDepth.txt all30GQ_chrMappingScaffolds_filteredMaxDepth.vcf