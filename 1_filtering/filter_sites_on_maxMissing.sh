#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J remove_sites
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

vcftools --vcf ../2_vcf_with_masked_genotypes_depth/parva_filtered_maxdp95_mindp5.recode.vcf --max-missing 0.90 --out parva_filtered_maxMissing_90 --recode --recode-INFO-all

vcftools --vcf ../2_vcf_with_masked_genotypes_depth/taiga_filtered_maxdp95_mindp5.recode.vcf --max-missing 0.90 --out taiga_filtered_maxMissing_90 --recode --recode-INFO-all

