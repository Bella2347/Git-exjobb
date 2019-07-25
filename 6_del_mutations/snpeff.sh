#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:00:00
#SBATCH -J snpEff
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools snpEff/4.3t

snpEff FicAlb_1.4.86 ../1_scaff_names/parva_chrContigs_keepBiallelic_maxDepth_maxMissingSite.NCBIv1.vcf > parva_chrContigs_snpeff.vcf



