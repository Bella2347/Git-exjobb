import sys
import re
from operator import eq

if not len(sys.argv)==4:
	print("\nError:\tincorrect number of command-line arguments")
	print("Syntax:\tind_depth_filtering.py [Input VCF] [Depth File] [Output VCF]\n")
	sys.exit()

if sys.argv[1]==sys.argv[3]:
	print("Error:\tInput file is the same as the output file - choose a different output file\n")
	sys.exit()

# Read in vcf file and depth file
vcf = open(sys.argv[1], 'r')
max_depths = open(sys.argv[2], 'r')
out = open(sys.argv[3], 'w+')


max_depth_list = []
# split the depths into a list
for line in max_depths:
	if not line.startswith('#'):
		max_depth_list.append(line.strip('\n'))

max_depths.close()

print("Max depths to be used:")
print(max_depth_list)

print("Masking sites...")
for line in vcf:
	# If it starts with info lines, keep those
	if line.startswith('#'):
		out.write(line)
	else:
		# Split into columns
		columns = line.split('\t')
		if not len(columns)-9 == len(max_depth_list):
			print("Error:\tNumber of samples in VCF does not match number of samples in depth file\n")
			sys.exit()

		depths = []
		for i in range(9,len(columns)):
			depths.append(columns[i].split(':')[2])
		# Generate list with true and false if samples dp is larger than filter dp for that
		logi_list = []
		for i in range(len(max_depth_list)):
			logi_list.append(depths[i] > max_depth_list[i])
		for i in range(len(logi_list)):
			if logi_list[i]:
				columns[i+9] = re.sub('\d/\d:','./.:', columns[i+9])
		masked_line = '\t'.join(columns)
		out.write(masked_line)

vcf.close()

print("Done!")
