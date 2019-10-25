# Script to write the prior probability for the ancestral state, one file per contig
import sys
import time

if not len(sys.argv)==2:
        print("\nError:\tincorrect number of command-line arguments")
        print("Syntax:\tprior_prob_state.py [State File]\n")
        sys.exit()

print("Writing prior probability for the ancestral state.\nInput file: " + sys.argv[1])

# Open file with the ancestral state
state = open(sys.argv[1], 'r')

contig = 'contig'
out = 'out-file'

t_start = time.time()

for line in state:
	if not line.startswith('#'):
		columns = line.strip('\n').split('\t')
		
		# Open a new out-file for each contig
		if not contig == columns[0]:
			# Skip closing first time since when out is initiated it is a string
			# I know that it is not pretty code
			if not out == 'out-file':
				out.close()
			contig = columns[0]
			out = open(contig+'.txt', 'w+')
			out.write('#Pos\tA\tC\tG\tT\n')
			print('Writing prior probabilities for '+ contig + '...')

		# Print prior probability in the order: A, C, G, T
		if columns[2] == '?':
			out.write(columns[1]+'\t'+'0.25\t0.25\t0.25\t0.25\n')
		if columns[2] == 'A':
			out.write(columns[1]+'\t'+'0.91\t0.03\t0.03\t0.03\n')
		if columns[2] == 'C':
                	out.write(columns[1]+'\t'+'0.03\t0.91\t0.03\t0.03\n')
		if columns[2] == 'G':
                	out.write(columns[1]+'\t'+'0.03\t0.03\t0.91\t0.03\n')
		if columns[2] == 'T':
                	out.write(columns[1]+'\t'+'0.03\t0.03\t0.03\t0.91\n')

out.close()
state.close()

elapsed = time.time() - t_start

print("Done! Ran in: %.2fs" % elapsed )
