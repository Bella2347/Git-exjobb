import sys
import re

prefix = sys.argv[1]
numThreads = sys.argv[2]


for i in range(3, len(sys.argv)):
	with open(sys.argv[i]) as chrFile:
		chrName = re.findall('Chr(\d+|\w+)\.txt', sys.argv[i])
		sys.stdout.write("ldhelmet find_confs --num_threads " + numThreads + " -w 50 -o " + prefix + ".chr-" + chrName[0] + ".conf ")
		for line in chrFile:
			line = line.strip('\n')
			sys.stdout.write("seq_files/" + prefix + ".chr-" + line + ".seq ")
		sys.stdout.write("\n\n")



