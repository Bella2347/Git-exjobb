#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 20:00:00
#SBATCH -J phasing_test_N20
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

module load bioinfo-tools fastPHASE/1.4.0

#fastPHASE -oparva_N00602_1phased -T50 -C30 -K6 -u../../0_data/parva_subpopulations.txt ../1_input_format/parva.chr-N00602.noP.inp

#fastPHASE -oparva_N00400_1phased -T50 -C30 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00400.noP.inp

#fastPHASE -oparva_N00300_1phased -T50 -C30 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00300.noP.inp

#fastPHASE -oparva_N00200_1phased -T50 -C30 -K6 -u../../0_data/parva_subpopulations.txt ../1_input_format/parva.chr-N00200.noP.inp

#fastPHASE -oparva_N00070_2phased -T50 -C25 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00070.noP.inp

#fastPHASE -oparva_N00070_5phased -T30 -C30 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00070.noP.inp

fastPHASE -oparva_N00020_phased_T20_C25 -T20 -C25 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00020.noP.inp

fastPHASE -oparva_N00020_phased_T20_C30 -T20 -C30 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00020.noP.inp

fastPHASE -oparva_N00020_phased_T30_C25 -T30 -C25 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00020.noP.inp

fastPHASE -oparva_N00020_phased_T30_C30 -T30 -C30 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00020.noP.inp

fastPHASE -oparva_N00020_phased_T50_C25 -T50 -C25 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00020.noP.inp

fastPHASE -oparva_N00020_phased_T50_C30 -T50 -C30 -K6 -u../0_data/parva_subpopulations.txt 1_input_format/parva.chr-N00020.noP.inp

#fastPHASE -oparva_N00001_1phased -T50 -C30 -K6 -u../../0_data/parva_subpopulations.txt ../1_input_format/parva.chr-N00001.noP.inp


