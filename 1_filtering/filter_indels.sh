#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J filter_indels
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

vcftools --vcf ../../0_data/subset_vcf/parva_chrContigs.vcf --max-alleles 2 --out parva_keepBiallelic --recode --recode-INFO-all

