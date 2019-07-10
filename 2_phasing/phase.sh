#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 2:00:00
#SBATCH -J phasing
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools fastPHASE/1.4.0

fastPHASE -oparva_N00001_phased_wSub -C25 -H-1 -g -KL3 -KU28 -KI5 -u../../0_data/parva_subpopulations.txt ../parva_N00001_noP.inp

fastPHASE -oparva_N00025_phased_wSub -C25 -H-1 -g -KL3 -KU28 -KI5 -u../../0_data/parva_subpopulations.txt ../1_input_format/parva.chr-N00025.recode.phase.inp

# fastPHASE -oparva_N00215_phased -C25 -H-1 -g -KL3 -KU28 -KI5 ../1_input_format/parva.chr-N00215.recode.phase.inp

# fastPHASE -oparva_N00323_phased -C25 -H-1 -g -KL3 -KU28 -KI5 ../1_input_format/parva.chr-N00323.recode.phase.inp

# fastPHASE -oparva_N00100_phased -C25 -H-1 -g -KL3 -KU28 -KI5 ../1_input_format/parva.chr-N00100.recode.phase.inp

