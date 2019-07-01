# Scrip to extract the ancestral state from a vcf file containing individuals from three groups
# Input is a vcf-file and a group-file which specify the number of individuals in each group, the individuals are assumed to appear in group order

import sys
import re
import time

if not len(sys.argv)==4:
        print("\nError:\tincorrect number of command-line arguments")
        print("Syntax:\tancestral_from_vcf.py [Input VCF] [Group File] [Output VCF]\n")
        sys.exit()

if sys.argv[1]==sys.argv[3]:
        print("\nError:\tinput-file and output-file are the same, choose another output-file\n")
        sys.exit()

# Open the input files
vcf =  open(sys.argv[1], 'r')
group_file =  open(sys.argv[2], 'r')
# Open output to write to
out = open(sys.argv[3], 'w+')

groups = []
for line in group_file:
        if not line.startswith('#'):
                ind =  line.strip('\n').split('\t')
                groups.append(int(ind[1]))

group_file.close()

out.write('#Chr\tPos\tState\n')

print("Finding the ancestral state...")

t_start = time.time()

for line in vcf:
	if not line.startswith('#'):
		# Split in to columns
		columns = line.strip('\n').split('\t')

		if not len(columns) == len(groups)+9:
                        print("Error:\tNumber of samples in VCF does not match number of samples in group-file\n")
                        sys.exit()

		# Save the ref and alt alleles
		alleles = []
		alleles.append(columns[3])
		alt_alleles = columns[4].split(',')
		for alt in alt_alleles:
			alleles.append(alt)


		group1_genotypes = []
		group2_genotypes = []
		group3_genotypes = []

		i_start = 9

		for i in range(i_start, len(columns)):
			genotype = re.findall('\d/\d', columns[i])
			if len(genotype) != 0:
				genotype = genotype[0].split('/')
				if groups[i-9] == 1:
					for alt in genotype:
						group1_genotypes.append(alt)
				if groups[i-9] == 2:
					for alt in genotype:
						group2_genotypes.append(alt)
				if groups[i-9] == 3:
					for alt in genotype:
						group3_genotypes.append(alt)


		# Check all genotypes in each group, if all are the same, save the genotype
		monomorphic = []
		if not any(element != group1_genotypes[0] for element in group1_genotypes):
			monomorphic.append(group1_genotypes[0])
		
		if not any(element != group2_genotypes[0] for element in group2_genotypes):
			monomorphic.append(group2_genotypes[0])

		if not any(element != group3_genotypes[0] for element in group3_genotypes):
			monomorphic.append(group3_genotypes[0])

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
		chr_pos = columns[0] + '\t' + columns[1] + '\t'
		out.write(chr_pos + state + '\n')

vcf.close()
out.close()

elapsed = time.time() - t_start

print("Done! Ran in: %.2fs" % elapsed )

