#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 00:50:00
#SBATCH -J min-max_filtering
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools vcftools/0.1.15

# --minDP sets the minimum depth
# --maxDP sets the maximum depth

vcftools --vcf ../0_data/parva.vcf --minDP 5 --maxDP 95 --recode --recode-INFO-all --out parva_filtered_maxdp95_mindp5

vcftools -vcf ../0_data/taiga.vcf --minDP 5 --maxDP 95 --recode --recode-INFO-all --out taiga_filtered_maxdp95_mindp5 

