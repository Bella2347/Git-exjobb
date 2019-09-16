import sys
import re

samples = []

with open(sys.argv[2], 'r') as sample_file:
	for line in sample_file:
		fields = line.strip('\n').split('\t')
		samples.append(fields[0])

out1 = open(sys.argv[3], 'w+')
out2 = open(sys.argv[4], 'w+')

write_to = "None"

with open(sys.argv[1], 'r') as seq_file:
	for line in seq_file:
		if line.startswith('>'):
			line_sample = re.search('>sample_(\d+)_', line)
			string = 'Sample_' + line_sample.group(1)
			if string in samples:
				write_to = 1
			else:
				write_to = 2

		if write_to == 1:
			out1.write(line)
		elif write_to == 2:
			out2.write(line)


out1.close()
out2.close()
			
