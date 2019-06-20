#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:00:00
#SBATCH -J DP_parva
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

vcftools --vcf ../2_vcf_with_masked_genotypes_depth/parva_filtered_maxdp95_mindp5.recode.vcf --max-missing 0.10 --out parva_filtered_maxMissing

vcftools --vcf ../2_vcf_with_masked_genotypes_depth/taiga_filtered_maxdp95_mindp5.recode.vcf --max-missing 0.10 --out taiga_filtered_maxMissing

