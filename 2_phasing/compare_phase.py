# Script to compare the haplotyp out from fastphase between the same contigs
# fastphase out have first been converted to ldhelemet inp

import sys


out_file = open(sys.argv[3], '+w')

with open(sys.argv[1], 'r') as file1, open(sys.argv[2], 'r') as file2:
	for line1, line2 in zip(file1, file2):
		if not line1.startswith('>'):
			bases1 = list(line1.strip('\n'))
			bases2 = list(line2.strip('\n'))
			if not len(bases1) == len(bases2):
				print("not same length!")
			for i in range(0,len(bases1)):
				if bases1[i] == bases2[i]:
					out_file.write('1 ')
				else:
					out_file.write('0 ')
			out_file.write('\n')
out_file.close()

