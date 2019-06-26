import sys
import re

vcf =  open(sys.argv[1], 'r')
ingroup_file =  open(sys.argv[2], 'r')
outgroup1_file =  open(sys.argv[3], 'r')
outgroup2_file =  open(sys.argv[4], 'r')


ingroup = [line.strip('\n') for line in ingroup_list]
outgroup1 = [line.strip('\n') for line in outgroup1_list]
outgroup2 = [line.strip('\n') for line in outgroup2_list]

sys.close(ingroup_file)
sys.close(outgroup1_file)
sys.close(outgroup2_file)


for line in vcf:
	if not line.startswith('#'):
		columns = line.strip('\n').split('\t')
		alleles = columns[2] #columns with the alleles

		ingroup_genotypes = []
		outgroup1_genotypes = []
		outgroup2_genotypes = []

		for i in range(9,end_of_ingroup):
			genotype = re.find('\d/\d', columns[i])
			if genotype != './.':
				ingroup_genotypes.append(genotype)

		for i in range(end_of_ingroup+1,end_of_outgroup1):
                        genotype = re.find('\d/\d', columns[i])
                        if genotype != './.':
                                outgroup1_genotypes.append(genotype)

		for i in range(end_of_outgroup1,end_of_outgroup2):
                        genotype = re.find('\d/\d', columns[i])
                        if genotype != './.':
                                outgroup2_genotypes.append(genotype)
		
		# If any are heterozygous it is false
		monomorphic = []
		if not any(element != ingroup_genotypes[0] for element in ingroup_genotypes):
			monomorphic.append(ingroup_genotype[0])
		
		if not any(element != outgroup1_genotypes[0] for element in outgroup1_genotypes):
                        monomorphic.append(outgroup1_genotype[0])

		if not any(element != outgroup2_genotypes[0] for element in outgroup2_genotypes):
                        monomorphic.append(outgroup2_genotype[0])

		# compare if all elements in monomorphic are the same, at least two

			# Print allele at position monomorphic

