# Script to extract only contigs specified in a file

import sys
import re


if not len(sys.argv)==4:
	print("\nError:\tincorrect number of command-line arguments")
	print("Syntax:\tind_depth_filtering.py [Input VCF] [Contig List] [Output VCF]\n")
	sys.exit()

if sys.argv[1]==sys.argv[3]:
	print("\nError:\tinput-file and output-file are the same, choose another output-file\n")
	sys.exit()


vcf_in = open(sys.argv[1], 'r')
contig_file = open(sys.argv[2], 'r')
vcf_out = open(sys.argv[3], 'w+')


contigs_list = []

for line in contig_file:
	if not line.startswith('#'):
		contigs_list.append(line.strip('\n'))

contig_file.close()


for line in vcf_in:
	line = line.strip('\n')

	if line.startswith('##contig'):
		line_contig = re.findall('ID=(\S+),', line)

		if line_contig[0] in contigs_list:
			vcf_out.write(line+'\n')

	elif line.startswith('#'):
		vcf_out.write(line+'\n')
	else:
		columns = line.split('\t')
		if columns[0] in contigs_list:
			vcf_out.write(line+'\n')



