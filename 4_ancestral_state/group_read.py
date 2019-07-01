import sys

group_file =  open(sys.argv[1], 'r')


groups = []
for line in group_file:
	if not line.startswith('#'):
		ind =  line.strip('\n').split('\t')
		groups.append(int(ind[1]))

group_file.close()

print(groups)

