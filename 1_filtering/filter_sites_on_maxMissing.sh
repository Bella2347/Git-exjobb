#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J remove_sites
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

vcftools --vcf parva_n00001_filtered.vcf --max-missing 0.90 --out parva_filtered_maxMissing_90 --recode --recode-INFO-all

#vcftools --vcf taiga --max-missing 0.90 --out taiga_filtered_maxMissing_90 --recode --recode-INFO-all

