#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J vcf_plink_fastphase
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools plink/1.90b4.9

plink --vcf ../../1_filtering/3_indels_remove/parva_n00001_maxDepth_maxMissingSite_keepBiallelic.recode.vcf --out parva_n00001 --recode fastphase --allow-extra-chr

