# Scrip to extract the ancestral state from a vcf file containing individuals from three groups
# Input is a vcf-file and a group-file which specify the number of individuals in each group, the individuals are assumed to appear in group order

import sys
import re

# Open the input files
vcf =  open(sys.argv[1], 'r')
group_file =  open(sys.argv[2], 'r')

# Save the number of individuals for each group in a list
group_len = [int(line.strip('\n')) for line in group_file]

group_file.close()


for line in vcf:
	if not line.startswith('#'):
		# Split in to columns
		columns = line.strip('\n').split('\t')

		# Save the ref and alt alleles
		alleles = []
		alleles.append(columns[3])
		alt_alleles = columns[4].split(',')
		for alt in alt_alleles:
			alleles.append(alt)


		ingroup_genotypes = []
		outgroup1_genotypes = []
		outgroup2_genotypes = []

		in_start = 9
		out1_start = group_len[0]+9
		out2_start = group_len[0]+int(group_len[1])+9
		
		# Go through all indv in a group and save the genotype
		for i in range(in_start, out1_start):
			genotype = re.findall('\d/\d', columns[i])
			if len(genotype) != 0:
				genotype = genotype[0].split('/')
				for alt in genotype:
					ingroup_genotypes.append(alt)

		for i in range(out1_start, out2_start):
			genotype = re.findall('\d/\d', columns[i])
			if len(genotype) != 0:
				genotype = genotype[0].split('/')
				for alt in genotype:
					outgroup1_genotypes.append(alt)

		for i in range(out2_start, len(columns)):
			genotype = re.findall('\d/\d', columns[i])
			if len(genotype) != 0:
				genotype = genotype[0].split('/')
				for alt in genotype:
					outgroup2_genotypes.append(alt)

		# Check all genotypes in each group, if all are the same, save the genotype
		monomorphic = []
		if not any(element != ingroup_genotypes[0] for element in ingroup_genotypes):
			monomorphic.append(ingroup_genotypes[0])
		
		if not any(element != outgroup1_genotypes[0] for element in outgroup1_genotypes):
			monomorphic.append(outgroup1_genotypes[0])

		if not any(element != outgroup2_genotypes[0] for element in outgroup2_genotypes):
			monomorphic.append(outgroup2_genotypes[0])

		# If at least two groups are monomorphic check if at least two are monomorphic for the same variant
		# If they are monomorphic for the same, print that allele, if not print a ?
		if len(monomorphic) == 2:
			if monomorphic[0] == monomorphic[1]:
				state = alleles[int(monomorphic[0])]
			else:
				state = '?'
		elif len(monomorphic) == 3:
			if monomorphic[0] == monomorphic[1]:
				state = alleles[int(monomorphic[0])]
			elif monomorphic[0] == monomorphic[2]:
				state = alleles[int(monomorphic[0])]
			elif monomorphic[1] == monomorphic[2]:
				state = alleles[int(monomorphic[1])]
			else:
				state = '?'
		else:
			state = '?'
		
		# Print the state and the chr and position
		out = columns[0] + '\t' + columns[1] + '\t'
		print(out + state)


