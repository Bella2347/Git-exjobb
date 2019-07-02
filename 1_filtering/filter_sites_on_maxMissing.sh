#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J remove_sites
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

vcftools --vcf ../1_depth_filter/parva_chrContigs_keepBiallelic_maxDepth.vcf --max-missing 0.90 --out parva_chrContigs_keepBiallelic_maxDepth_maxMissingSite --recode --recode-INFO-all

