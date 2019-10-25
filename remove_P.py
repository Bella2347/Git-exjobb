# Script to remove the position row in the fastphase.inp files and saves the positions in 
# a separate file indexed from 0

import sys
import re


in_file = open(sys.argv[1], 'r')

out_name = re.findall('(.+)\.recode', sys.argv[1])
inp_out = open(out_name[0]+'.noP.inp', 'w+')
pos_out = open(out_name[0]+'.pos', 'w+')


for line in in_file:
	if line.startswith('P'):
		pos = line.strip('\n').strip(' ').split(' ')
		pos = pos[1:]	# Remove the P in the begining
		for i in range(0,len(pos)):
			pos[i] = str(int(pos[i])-1) # Subtracts 1 to make the index from 0
		pos = '\n'.join(pos)
		pos_out.write(pos)
	else:
		inp_out.write(line)

in_file.close()
inp_out.close()
pos_out.close()


