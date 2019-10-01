import sys
import re

scaffold = re.findall('N\d+', sys.argv[1])

missingCount = []

with open(sys.argv[1], 'r') as genotypeFile:
	lineNr = 0
	for line in genotypeFile:
		lineNr = lineNr + 1
		if line.startswith(('?','A','G','C','T')):
			line = line.strip('\n')
			genotypes = list(line)

			for i in range(1,len(genotypes)):
				if genotypes[i] == '?':
					missingCount[i] = missingCount[i] + 1
		elif lineNr == 2:
			nrSnps = line.strip('\n')
			missingCount = [0]*int(nrSnps)
	

print(scaffold[0] + ' ' + ' '.join(str(x) for x in missingCount))
			

