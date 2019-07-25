#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:00:00
#SBATCH -J sift4G
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

java -jar /home/bella/SIFT4G_Annotator_v2.4.jar -c -t -i 1_scaff_names/parva_chrContigs_keepBiallelic_maxDepth_maxMissingSite.NCBIv1.vcf -d /home/bella/FicAlb_1.4.83/ -r /proj/sllstore2017033/nobackup/work/bella/6_del_mutations/

