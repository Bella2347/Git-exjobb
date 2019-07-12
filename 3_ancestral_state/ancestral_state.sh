#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J test_ancestral_state
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

python3 ../../Git-exjobb/3_ancestral_state/ancestral_from_vcf.py ../../1_filtering/3_indels_remove/parva_n00001_maxDepth_maxMissingSite_keepBiallelic.recode.vcf parva_subpopulations.txt parva_n00001_test.state.txt

