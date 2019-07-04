#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 05:00:00
#SBATCH -J ldhelmet_pade
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools LDhelmet/1.10

ldhelmet pade --num_threads 10 -c seq_files/parva_N00042_LDhelmetInp.seq -o parva_N00042 -t 0.01 -x 11



