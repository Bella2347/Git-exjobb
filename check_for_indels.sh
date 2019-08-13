#!/bin/bash -l
#SBATCH -A p2018002
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -J checkForIndels
#SBATCH --mail-type=ALL
#SBATCH --mail-user bsm.sinclair@gmail.com

grep '*' allGQ30.vcf
