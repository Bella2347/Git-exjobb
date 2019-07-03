# Script to extract only contigs specified in a file

import sys
import re
import time



if not len(sys.argv)==4:
	print("\nError:\tincorrect number of command-line arguments")
	print("Syntax:\tchr_mapping_contigs.py [Input VCF] [Contig List] [Output VCF]\n")
	sys.exit()

if sys.argv[1]==sys.argv[3]:
	print("\nError:\tinput-file and output-file are the same, choose another output-file\n")
	sys.exit()

print("Create VCF with only contigs in contigs file.")
print("Input file: " + sys.argv[1] + "\nContigs list: " + sys.argv[2] + "\nOut file: " + sys.argv[3])

vcf_in = open(sys.argv[1], 'r')
contig_file = open(sys.argv[2], 'r')
vcf_out = open(sys.argv[3], 'w+')



t_start = time.time()

print("Reading contigs file...")



contigs_list = []

for line in contig_file:
	if not line.startswith('#'):
		contigs_list.append(line.strip('\n'))

contig_file.close()



print("Writing lines to out file...")

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

vcf_in.close()
vcf_out.close()



elapsed = time.time() - t_start

print("Done! Ran in: %.2fs" % elapsed )

