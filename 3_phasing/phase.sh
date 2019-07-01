#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:00:00
#SBATCH -J phasing
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools fastPHASE/1.4.8

fastPHASE -oparva_n00001_phased -C50 -KL5 -KU15 -KI5 ../2_input_format/1_chrFal34/parva_plink_chrFal34..chr-N00705.recode.phase.inp

