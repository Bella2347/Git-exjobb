import sys
import re
import time

if not len(sys.argv)==3:
        print('\nError:\tincorrect number of command-line arguments')
        print('Syntax:\tldhelmet_inp.py [FastPHASE Output] [Output File]\n')
        sys.exit()

if sys.argv[1]==sys.argv[2]:
        print('\nError:\tinput-file and output-file are the same, choose another output-file\n')
        sys.exit()

fastphase_file = open(sys.argv[1], 'r')
out_file = open(sys.argv[2], 'w+')

print('Input: ' + sys.argv[1] + '\nOutput: ' + sys.argv[2])

print_line = 0

t_start = time.time()

print('Converting fastPHASE output to LDhelmet input...')


haplotype = 1
	
for line in fastphase_file:
	if not line.startswith('END GENOTYPES'):
		if line.startswith('# ID'):
			sample_id = re.findall('#\sID\s(\d+)', line)
			out_file.write('>sample_' + sample_id[0] + '_' + str(haplotype) + '\n')
			print_line = 1
		elif print_line == 1:
			if haplotype == 1:
				haplotype = 2
			else:
				out_file.write('>sample_' + sample_id[0] + '_' + str(haplotype) + '\n')
				haplotype = 1
			bases = line.strip('\n').split(' ')
			sequence = ''.join(bases)
			out_file.write(sequence + '\n')

fastphase_file.close()
out_file.close()

elapsed = time.time() - t_start

print('Done! Ran in: %.2fs' % elapsed)

