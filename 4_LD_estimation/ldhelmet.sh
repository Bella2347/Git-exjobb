#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 20:00:00
#SBATCH -J ldhelmet
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools LDhelmet/1.10

# Configuration table
ldhelmet find_confs --num_threads 5 -w 50 -o 1_input_format/parva_N70_N400.conf 1_input_format/seq_files/parva_N00070_1ldhelmet.inp.seq 1_input_format/seq_files/parva_N00400_ldhelmet.inp.seq

# Likelihood lookup table
ldhelmet table_gen --num_threads 5 -c 1_input_format/parva_N70_N400.conf -t 0.01 -r 0.0 0.1 10.0 1.0 100.0 -o 1_input_format/parva_N70_N400.lk

# Algorithm
ldhelmet rjmcmc --num_threads 5 -w 50 -l 1_input_format/parva_N70_N400.lk -b 10 --snps_file 1_input_format/seq_files/parva_N00400_ldhelmet.inp.seq --pos_file 1_input_format/pos_files/parva.chr-N00400.pos -m 1_input_format/mut_mat.txt --burn_in 100000 -n 1000000 -o parva_N00400.post

ldhelmet rjmcmc --num_threads 5 -w 50 -l 1_input_format/parva_N70_N400.lk -b 10 --snps_file 1_input_format/seq_files/parva_N00070_1ldhelmet.inp.seq --pos_file 1_input_format/pos_files/parva.chr-N00070.pos -m 1_input_format/mut_mat.txt --burn_in 100000 -n 1000000 -o parva_N00070.post

# Extract info
ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o parva_N00400_out.txt parva_N00400.post
ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o parva_N00070_out.txt parva_N00070.post



