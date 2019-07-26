#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 24:00:00
#SBATCH -J ldhelmet_v1.7_2fasta
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools LDhelmet/1.7

# Configuration table
ldhelmet find_confs --num_threads 10 -w 50 -o 1_input_format/parva_N70_N400_2fasta_v1.7.conf 1_input_format/fasta_files/parva_N00070.full_seq.fasta 1_input_format/fasta_files/parva_N00400.full_seq.fasta

# Likelihood lookup table
ldhelmet table_gen --num_threads 10 -c 1_input_format/parva_N70_N400_2fasta_v1.7.conf -t 0.01 -r 0.0 0.1 10.0 1.0 100.0 -o 1_input_format/parva_N70_N400_2fasta_v1.7.lk

# Algorithm
ldhelmet rjmcmc --num_threads 10 -w 50 -l 1_input_format/parva_N70_N400_2fasta_v1.7.lk -b 10 --snps_file 1_input_format/seq_files/parva_N00400_1phased_hapguess_switch.out.ld.seq --pos_file 1_input_format/pos_files/parva.chr-N00400.pos -m 1_input_format/mut_mat.txt --burn_in 100000 -n 1000000 -o parva_N00400_2fasta_v1.7.post

ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o parva_N00400_out_2fasta_v1.7.txt parva_N00400_2fasta_v1.7.post


ldhelmet rjmcmc --num_threads 10 -w 50 -l 1_input_format/parva_N70_N400_2fasta_v1.7.lk -b 10 --snps_file 1_input_format/seq_files/parva_N00070_1phased_hapguess_switch.out.ld.seq --pos_file 1_input_format/pos_files/parva.chr-N00070.pos -m 1_input_format/mut_mat.txt --burn_in 100000 -n 1000000 -o parva_N00070_2fasta_v1.7.post

ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o parva_N00070_out_2fasta_v1.7.txt parva_N00070_2fasta_v1.7.post

# Using fasta files instead of SNP-files
#ldhelmet rjmcmc --num_threads 10 -w 50 -l 1_input_format/parva_N70_N400_fasta.lk -b 10 -s 1_input_format/fasta_files/parva_N00400.full_seq.fasta -m 1_input_format/mut_mat.txt --burn_in 100000 -n 1000000 -o parva_N00400_fastafasta.post

#ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o parva_N00400_out_fastafasta.txt parva_N00400_fastafasta.post


#ldhelmet rjmcmc --num_threads 10 -w 50 -l 1_input_format/parva_N70_N400_fasta.lk -b 10 -s 1_input_format/fasta_files/parva_N00070.full_seq.fasta -m 1_input_format/mut_mat.txt --burn_in 100000 -n 1000000 -o parva_N00070_fastafasta.post

#ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.0975 -o parva_N00070_out_fastafasta.txt parva_N00070_fastafasta.post

