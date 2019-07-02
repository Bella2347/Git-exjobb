#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J extracting_contigs_that_mapp_chr
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

python3 ../../Git-exjobb/chr_mapping_contigs.py ../parva.vcf ../contigs_lists/chr_mapping_contigs.txt parva_chrContigs.vcf

