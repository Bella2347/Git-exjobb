#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 3
#SBATCH -t 05:00:00
#SBATCH -J phasing
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools fastPHASE/1.4.8

fastPHASE -oparva_N00012_phased -C50 -KL5 -KU15 -KI5 1_input_format/parva.chr-N00042.recode.phase.inp

