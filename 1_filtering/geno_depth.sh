#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J DP_parva
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

vcftools --vcf ../3_removed_sites_with_missing-genotype/parva_filtered_maxMissing.recode.vcf --out parva_maxMissing --geno-depth

