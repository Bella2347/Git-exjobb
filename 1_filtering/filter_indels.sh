#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:10:00
#SBATCH -J filter_indels
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

vcftools --vcf ../2_missing_remove_sites/parva_n00001_maxDepth_maxMissingSite.recode.vcf --max-alleles 2 --out parva_n00001_maxDepth_maxMissingSite_keepBiallelic --recode --recode-INFO-all

