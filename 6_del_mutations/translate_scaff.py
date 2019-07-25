# Script that takes a vcf and a text file with new scaffold names and positions and replaces
# the old with the new ones

import sys


vcf_out = open(sys.argv[3], 'w+')

names_list = []

with open(sys.argv[2], 'r') as new_names:
	for line in new_names:
		names_list.append(line.strip('\n').split('\t'))

it = 0
with open(sys.argv[1], 'r') as vcf_in:
	for line in vcf_in:
		if not line.startswith('#'):
			fields = line.split('\t')
			fields[0] = names_list[it][0]
			fields[1] = names_list[it][1]
			new_line = '\t'.join(fields)
			vcf_out.write(new_line)
			it = it + 1
		else:
			vcf_out.write(line)

vcf_out.close()



