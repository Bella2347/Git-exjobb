import sys
import re
import time
from operator import eq

def isfloat(value):
# Method to check if string can be converted to a float
	try:
		float(value)
		return True
	except ValueError:
		return False

if not len(sys.argv)==4:
	print("\nError:\tincorrect number of command-line arguments")
	print("Syntax:\tind_depth_filtering.py [Input VCF] [Depth File] [Output VCF]\n")
	sys.exit()

if sys.argv[1]==sys.argv[3]:
	sys.exit()

# Read in vcf file and depth file
vcf = open(sys.argv[1], 'r')
max_depths = open(sys.argv[2], 'r')
# Open the outfile for writing
out = open(sys.argv[3], 'w+')


# Initiate a list with the filtering depths
max_depth_list = []
# Save the filtering depths from the depth-file to the list
for line in max_depths:
	if not line.startswith('#'):
		max_depth_list.append(float(line.strip('\n')))

max_depths.close()

print("Max depths to be used:")
print(max_depth_list*3)


start = time.time()

print("Masking sites...")
# Step through each line in the vcf...
for line in vcf:
	# print the lines that starts with # directoly to the out-file
	if line.startswith('#'):
		out.write(line)
	else:
		# Split the variant lines into columns
		columns = line.strip('\n').split('\t')
		# In the 10th column the info for each sample start, check that the number of samples in the vcf and depth-file are the same
		if not len(columns)-9 == len(max_depth_list):
			print("Error:\tNumber of samples in VCF does not match number of samples in depth file\n")
			sys.exit()
		# Initiate a list for the depth of each sample for a variant
		depths = []
		# Step through all sample columns and extract the DP (3rd field)
		for i in range(9,len(columns)):
			depths.append(columns[i].split(':')[2])
		# If the depth for that variant is larger than the value for that sample in the depth-file the genotype is masked
		for i in range(len(max_depth_list)):
			if isfloat(depths[i]):
				if float(depths[i]) > 3*max_depth_list[i]:
					columns[i+9] = re.sub('\d/\d:','./.:', columns[i+9])
		# Join all columns again, tab-separated
		masked_line = '\t'.join(columns)
		# Write the filtered line to the out-file
		out.write(masked_line+"\n")

vcf.close()
elapsed = time.time() - start

print("Done! Ran in: %.2fs" % elapsed )
