#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J extractingScaffoldsThatMappToChr
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

python3 ../Git-exjobb/chr_mapping_contigs.py allGQ30.vcf contigs_lists/chr_mapping_scaffolds.txt allGQ30_chrMappingScaffolds.vcf

