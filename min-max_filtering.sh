#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 03:00:00
#SBATCH -J min-max_filtering
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

# --minDP sets the minimum depth
# --maxDP sets the maximum depth
# --missing-indv gives the number of how missingness there are on the individual level (missing SNPs/indv)
# --missing-site the missing genotype/site

vcftools --vcf ../0_data/parva.vcf --minDP 5 --maxDP 100 --missing-indv --missing-site --recode --redoce-INFO-all --out parva_filtered_depth

