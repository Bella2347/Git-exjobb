#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J chr_contigs_to_vcf
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

# Adds the first info lines
cat ../1_vcf_head/1_info_lines.txt > chrFal34.vcf
#parva_chrContigs.vcf

# Adds the contigs present in this files
while read LINE; do grep "$LINE" ../1_vcf_head/2_contigs.txt >> chrFal34.vcf; done < ../2_chr_contigs/ChrFal34.txt 

# Adds the head that explains each column
cat ../1_vcf_head/3_head.txt >> chrFal34.vcf
#parva_chrContigs.vcf

# Adds all the SNPs in the contigs specified
while read LINE; do grep "^$LINE" ../../../1_filtering/3_removed_sites_with_missing-genotype/parva_filtered_maxMissing_90.recode.vcf >> chrFal34.vcf; done < ../2_chr_contigs/ChrFal34.txt
