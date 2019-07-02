#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J missing_stats
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

# --missing-indv gives the number of how missingness there are on the individual level (missing SNPs/indv)
# --missing-site the missing genotype/site

vcftools --vcf parva_filtered_maxdp95_mindp5.recode.vcf --missing-indv --out parva_maxdp95_mindp5_missing_indv
vcftools --vcf parva_filtered_maxdp95_mindp5.recode.vcf --missing-site --out parva_maxdp95_mindp5_missing_site

vcftools --vcf taiga_filtered_maxdp95_mindp5.recode.vcf --missing-indv --out taiga_maxdp95_mindp5_missing_indv
vcftools --vcf taiga_filtered_maxdp95_mindp5.recode.vcf --missing-site --out taiga_maxdp95_mindp5_missing_site

