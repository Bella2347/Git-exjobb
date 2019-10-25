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
	print("\nError:\tinput-file and output-file are the same, choose another output-file\n")
	sys.exit()

print("Filter on individual max depth.")
print("Input file: " + sys.argv[1] + "\nDepth file: " + sys.argv[2] + "\nOut file: " + sys.argv[2])

vcf = open(sys.argv[1], 'r')
filter_depths = open(sys.argv[2], 'r')
out = open(sys.argv[3], 'w+')


filter_depth_list = []

for line in filter_depths:
	if not line.startswith('#'):
		filter_depth_list.append(float(line.strip('\n')))

filter_depths.close()


print("Avg depths to be used:")
print(filter_depth_list)


# The max depth is set to the average depth times this number
times_avg_depth = 2

start = time.time()

print("Masking sites...")

for line in vcf:
	# print the lines that starts with # directly to the out-file
	if line.startswith('#'):
		out.write(line)
	else:
		columns = line.strip('\n').split('\t')
		# In the 10th column the info for each sample start (9th when index start at 0)
		if not len(columns)-9 == len(filter_depth_list):
			print("Error:\tNumber of samples in VCF does not match number of samples in depth-file\n")
			sys.exit()

		# Mask only if DP information is aviable
		if len(re.findall(':', columns[8])) > 0:

			dp_index = columns[8].split(':').index('DP')
			depths = []
			for i in range(9,len(columns)):
				depths.append(columns[i].split(':')[dp_index])

			for i in range(len(filter_depth_list)):
				if isfloat(depths[i]):
					if float(depths[i]) > times_avg_depth*filter_depth_list[i]:
						columns[i+9] = re.sub('\d/\d:','./.:', columns[i+9])

			masked_line = '\t'.join(columns)

			out.write(masked_line+"\n")
		else:
			# If the line does not contain any DP information, write it as it is and give the position
			out.write(line)
			print("No DP information at: " + columns[0] + ", " + columns[1])

vcf.close()
out.close()
elapsed = time.time() - start

print("Done! Ran in: %.2fs" % elapsed )
