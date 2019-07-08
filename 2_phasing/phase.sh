#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 3
#SBATCH -t 05:00:00
#SBATCH -J phasing
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools fastPHASE/1.4.0

fastPHASE -oparva_N00049_phased_140 -C50 -KL5 -KU25 -KI5 ../1_input_format/parva.chr-N00049.recode.phase.inp

