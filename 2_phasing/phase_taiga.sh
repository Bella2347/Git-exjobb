#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 10:00:00
#SBATCH -J phasing_test_N20
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools fastPHASE/1.4.0

# Select K
fastPHASE -otaiga_N00270_phased_T20_C25 -T20 -C25 -KL2 -KU26 -KI2 -u../0_data/taiga_subpopulations.txt 1_input_format/taiga.chr-N00270.noP.inp

fastPHASE -otaiga_N00139_phased_T20_C25 -T20 -C25 -KL2 -KU26 -KI2 -u../0_data/taiga_subpopulations.txt 1_input_format/taiga.chr-N00139.noP.inp

fastPHASE -otaiga_N00033_phased_T20_C25 -T20 -C25 -KL2 -KU26 -KI2 -u../0_data/taiga_subpopulations.txt 1_input_format/taiga.chr-N00033.noP.inp




