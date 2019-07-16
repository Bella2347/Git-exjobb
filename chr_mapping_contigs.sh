#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:00:00
#SBATCH -J extracting_contigs_that_mapp_chr
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

python3 ../../Git-exjobb/chr_mapping_contigs.py ../taiga.vcf ../contigs_lists/chr10.txt taiga_chr10Contigs.vcf

