#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 00:30:00
#SBATCH -J missing stats
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

# --minDP sets the minimum depth
# --maxDP sets the maximum depth
# --missing-indv gives the number of how missingness there are on the individual level (missing SNPs/indv)
# --missing-site the missing genotype/site

vcftools --vcf parva_filtered_depth.recode.vcf --missing-indv --out parva_missing_indv
vcftools --vcf parva_filtered_depth.recode.vcf --missing-site --out parva_missing_site

