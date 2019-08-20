# Makes a new vcf with only individuals in indiv-list
# Prints to stout so it can be piped to a filtering tool

import sys
import re

if not len(sys.argv)==3:
	print("\nError:\tincorrect number of command-line arguments")
	print("Syntax:\textract_indiv.py [Indiv-list] [Input VCF]\n")
	sys.exit()

indiv_list = []

with open(sys.argv[1], 'r') as indiv_file:
	for line in indiv_file:
		indiv_list.append(line.strip('\n'))

print_index = [0,1,2,3,4,5,6,7,8]

with open(sys.argv[2], 'r') as vcf_file:
	for line in vcf_file:
		line = line.strip('\n')
		if line.startswith('##'):
			print(line)
		else:
			columns = line.split('\t')
			
			if line.startswith('#C'):
				for i in range(9,len(columns)):
					if columns[i] in indiv_list:
						print_index.append(i)
			out_line = []
			for i in print_index:
				out_line.append(columns[i])
			print('\t'.join(out_line))


