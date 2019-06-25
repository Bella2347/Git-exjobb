# mock script

# input: script.py vcf-file mask-file out-file

# mask-file
# chr	pos	ind_#
# ex
# 1	10	2 7 9
# 2	15	1 2
# ...



# Read in files to read and write to out
open(vcf-file, read)
open(mask-file, read)
open(out-file, write)


# For each line in the file with the genotypes to mask split into two
for line in mask:
	mask_hash = line.split('\t', 3)

for line in vcf:
	# If it starts with info lines, keep those
	if line '^#':
		write to out
	else:
		# Split into columns
		row = line.split('\t')
		i = 0
		# Go through all rows in the mask-file
		while true:
			i = i + 1
			# If the chromosome match...
			if mask_hash[1,i] == row[1]:
				# and the position...
				if mask_hash[2,i] == row[2]:
					# Split the last field in the mask_hash on space to get the sample to mask
					mask_geno = mask_hash[3].split(" ")
					# Go though all samples that will be masked
					for n in mask_geno:
						# mask_geno[n] contains a number, take that numbered column (ish)
						# find the genotype and replace it with './.' masking it
						row[mask_geno[n]] = sub('\d/\d:','./.:', row[mask_geno[n]])
					write row to out
					# the position is found, no need to look through the rest of mask_hash
					false







