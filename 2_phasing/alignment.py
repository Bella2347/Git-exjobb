# Script to convert phased haplotypes to 1 and 0 to make easy visual of alignments in R
# Input is assumed to be converted to ldhelmet inp

import sys


out_file = open(sys.argv[3], '+w')

alleles = []

with open(sys.argv[2], 'r') as allele_file:
	for line in allele_file:
		alleles.append(list(line.strip('\n')))

with open(sys.argv[1], 'r') as hap_file:
	for line in hap_file:
		if not line.startswith('>'):
			bases = list(line.strip('\n'))
			for i in range(0,len(bases)):
				if bases[i] == alleles[i][0]:
					out_file.write('1 ')
				else:
					out_file.write('0 ')
			out_file.write('\n')
out_file.close()

