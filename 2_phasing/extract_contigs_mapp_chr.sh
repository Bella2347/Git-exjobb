#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 05:00:00
#SBATCH -J chr_contigs_to_vcf
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

# Adds the first info lines
cat 1_vcf_head/1_info_lines.txt > parva_chrContigs.vcf

# Adding contigs present in this files
while read LINE; do grep "$LINE" 1_vcf_head/2_contigs.txt >> parva_chrContigs.vcf; done < 2_contigs_list/chr_mapping_contigs.txt 

# Adds the head that explains each column
cat 1_vcf_head/3_head.txt >> parva_chrContigs.vcf

# Adds all the SNPs in the contigs specified
while read LINE; do grep "^$LINE" ../../1_filtering/3_indels_remove/parva_maxDepth_maxMissingSite_keepBiallelic.recode.vcf >> parva_chrContigs.vcf; done < 2_chr_contigs/chr_mapping_contigs.txt

