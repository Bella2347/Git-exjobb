import sys
import re
import time


def write_id(name, file):
        file.write('>sample_' + name + '\n')

def write_seq(line, file):
	sequence = ''.join(line)
	file.write(sequence + '\n')



if not len(sys.argv)==3 and not len(sys.argv)==4:
        print('\nError:\tincorrect number of command-line arguments')
        print('Syntax:\tldhelmet_inp.py [FastPHASE Output] [Output File] optional: [Subset of samples]\n')
        sys.exit()

if sys.argv[1] == sys.argv[2]:
		print('\nError:\tinput-file and output-file are the same, choose another output-file\n')
		sys.exit()



print('Input: ' + sys.argv[1] + '\tOutput: ' + sys.argv[2])


subset_samples = []

if len(sys.argv) == 4:
	print('Output contain only subset of samples:')

	with open(sys.argv[3], 'r') as sample_file:
		for line in sample_file:
			line = line.strip('\n')
			subset_samples.append(line)

	print(','.join(subset_samples))



t_start = time.time()

print('Converting fastPHASE output to LDhelmet input...')


out_file = open(sys.argv[2], 'w+')
haplotype = 0
sample_id = 'None'

with open(sys.argv[1], 'r') as fastphase_file:
	for line in fastphase_file:

		line_split = line.strip('\n').split(' ')

		if line.startswith('# ID'):
			sample_id = line_split[2]
			if len(subset_samples) == 0 or sample_id in subset_samples:
				haplotype = 1
				write_id(sample_id + '_' + str(haplotype), out_file)
			else:
				haplotype = 0

		elif haplotype == 1:
			write_seq(line_split, out_file)
			haplotype = 2

		elif haplotype == 2:
			write_id(sample_id + '_' + str(haplotype), out_file)
			write_seq(line_split, out_file)
			haplotype = 0


elapsed = time.time() - t_start

print('Done! Ran in: %.2fs' % elapsed)

out_file.close()
