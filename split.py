import re
import sys

length = int(sys.argv[2])

with open('out.inp', 'w+') as out:
	with open(sys.argv[1], 'r') as file:
		for line in file:
			line = line.strip('\n')
			line_l = list(line)
			if len(line_l) > 20:
				out.write(''.join(line_l[0:length])+'\n')
			elif re.match('\d{7}', line):
				out.write(str(length) + '\n')
			else:
				out.write(line+'\n')


