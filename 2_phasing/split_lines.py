import sys
import re
import math

inp_file = open(sys.argv[1], 'r')

filename = re.findall('(\w+\.chr-\w+.noP).inp', sys.argv[1])

out_file = open(str(filename[0] + '.splitLines.inp'), 'w+')

max_len = 900000

for line in inp_file:
	line = line.strip('\n')
	characters = list(line)
	if len(characters) > max_len:
		nr_split = math.ceil(len(characters)/max_len)
		size_split = math.ceil(len(characters)/nr_split)
		if nr_split == 2:
			out_file.write(''.join(characters[0:size_split]) + '\n')	
		else:
			for i in range(0,(nr_split-2)):
				out_file.write(''.join(characters[i*size_split:(i+1)*size_split]) + '\n')
		out_file.write(''.join(characters[(nr_split-1)*size_split:len(characters)]) + '\n')
	else:
		out_file.write(line + '\n')

out_file.close()
inp_file.close()

