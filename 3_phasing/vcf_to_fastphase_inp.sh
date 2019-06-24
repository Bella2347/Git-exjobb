#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J vcf_plink_fastphase
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools plink/1.90b4.9

plink --vcf parva_chrContigs.vcf --out parva_plink_chrContigs --recode fastphase --allow-extra-chr

