#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J sort_vcf
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools BEDTools/2.27.1

bedtools sort -chrThenSizeA -i parva_chrContigs_keepBiallelic_maxDepth_maxMissingSite.NCBIv1.vcf

