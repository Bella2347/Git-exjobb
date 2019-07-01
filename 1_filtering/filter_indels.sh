#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J filter_indels
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

vcftools --vcf parva_n00001_filtered_maxMissing_90.recode.vcf --remove-indels --out parva_n00001_maxdepth_maxmissing_indels --recode --recode-INFO-all

