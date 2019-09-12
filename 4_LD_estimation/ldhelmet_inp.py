import sys
import re
import time


def write_id(name, file):
        file.write('>sample_' + name + '\n')

def write_seq(line, file):
	sequence = ''.join(line)
	file.write(sequence + '\n')



if not len(sys.argv)>=3:
        print('\nError:\tincorrect number of command-line arguments')
        print('Syntax:\tldhelmet_inp.py [FastPHASE Output] [Output File subpop. 1] optional: [[Output File subpop. 2] [Output File subpop. 3] ...\n')
        sys.exit()


out_files = [None]*(len(sys.argv)-2)

for i in range(2,len(sys.argv)):
	out_files[i-2] = open(sys.argv[i], 'w+')


for f in out_files:
	if out_files.count(f) > 1:
		print('\nError:\tinput-file and one output-file are the same, choose another output-file\n')
		sys.exit()


print('Input: ' + sys.argv[1] + '\tOutput: ' + '\t'.join(sys.argv[2:len(sys.argv)]))

t_start = time.time()

print('Converting fastPHASE output to LDhelmet input...')



haplotype = 0
sample_id = 'None'
sub_lab = 0

with open(sys.argv[1], 'r') as fastphase_file:
	for line in fastphase_file:

		line_split = line.strip('\n').split(' ')

		if line.startswith('# ID'):
			haplotype = 1
			sample_id = line_split[2]

			if len(line_split) > 3:
				sub_lab = int(line_split[7]) - 1

			write_id(sample_id + '_' + str(haplotype), out_files[sub_lab])

		elif haplotype == 1:
			write_seq(line_split, out_files[sub_lab])
			haplotype = 2

		elif haplotype == 2:
			write_id(sample_id + '_' + str(haplotype), out_files[sub_lab])
			write_seq(line_split, out_files[sub_lab])
			haplotype = 0


elapsed = time.time() - t_start

print('Done! Ran in: %.2fs' % elapsed)

for f in out_files:
	f.close()
