#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 10:00:00
#SBATCH -J vcf_plink_fastphase
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools plink/1.90b4.9

plink --vcf ../../1_filtering/1_genotype_depth/parva_filtered_n00001.vcf --out parva_plink_n00001 --recode fastphase-1chr --allow-extra-chr

