#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J vcf_plink_fastphase
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools plink/1.90b4.9

plink --vcf ../../1_filtering/2_missing_remove_sites/parva_chrContigs_keepBiallelic_maxDepth_maxMissingSite.recode.vcf --out parva --recode fastphase --allow-extra-chr

