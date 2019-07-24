#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 24:00:00
#SBATCH -J ldhelmet_fasta_mask
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools LDhelmet/1.10

# Configuration table
ldhelmet find_confs --num_threads 10 -w 50 -o 1_input_format/parva_N70_N400_fasta_mask.conf 1_input_format/fasta_files/parva_N00070.full_seq.ref_fasta_masked.fasta 1_input_format/fasta_files/parva_N00400.full_seq.ref_fasta_masked.fasta

# Likelihood lookup table
ldhelmet table_gen --num_threads 10 -c 1_input_format/parva_N70_N400_fasta_mask.conf -t 0.01 -r 0.0 0.1 10.0 1.0 100.0 -o 1_input_format/parva_N70_N400_fasta_mask.lk

# Algorithm
ldhelmet rjmcmc --num_threads 10 -w 50 -l 1_input_format/parva_N70_N400_fasta_mask.lk -b 10 --snps_file 1_input_format/seq_files/parva_N00400_1phased_hapguess_switch.out.ld.seq --pos_file 1_input_format/pos_files/parva.chr-N00400.pos -m 1_input_format/mut_mat.txt --burn_in 100000 -n 1000000 -o parva_N00400_fasta_mask.post

ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o parva_N00400_out_fasta_mask.txt parva_N00400_fasta_mask.post


ldhelmet rjmcmc --num_threads 10 -w 50 -l 1_input_format/parva_N70_N400_fasta_mask.lk -b 10 --snps_file 1_input_format/seq_files/parva_N00070_1phased_hapguess_switch.out.ld.seq --pos_file 1_input_format/pos_files/parva.chr-N00070.pos -m 1_input_format/mut_mat.txt --burn_in 100000 -n 1000000 -o parva_N00070_fasta_mask.post

ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o parva_N00070_out_fasta_mask.txt parva_N00070_fasta_mask.post




