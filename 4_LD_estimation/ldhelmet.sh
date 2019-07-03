#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 05:00:00
#SBATCH -J ldhelmet
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools LDhelmet/1.10

ldhelmet rjmcmc -o parva_N00042 --pos_file 1_input_format/pos_files/parva_N00042.pos \
--snps_file 1_input_format/seq_files/parva_N00042_LDhelmetInp.seq \
-n 2000000 --burn_in 200000 -b 10 -m 1_input_format/mut_mat.txt --num_threads 5 -w 50

