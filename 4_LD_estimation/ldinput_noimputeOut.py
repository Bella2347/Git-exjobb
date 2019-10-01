import sys

haplotype = 0
sample_id = 'None'

with open(sys.argv[1], 'r') as phaseOut:
	for line in phaseOut:
		
		line = line.strip('\n')
		line_list = list(line)

		if line.startswith('# ID'):
			line_split = line.split(' ')
			sample_id = line_split[2]
			haplotype = 1

		elif haplotype == 1:
			print('>sample_' + sample_id + '_' + str(haplotype))

			line_list_2nd_ele = line_list[::2]
			sequence = ['N' if x=='\x00' else x for x in line_list_2nd_ele]
			print(''.join(sequence))

			haplotype = 2

		elif haplotype == 2:
			print('>sample_' + sample_id + '_' + str(haplotype))
			
			line_list_2nd_ele = line_list[::2]
			sequence = ['N' if x=='\x00' else x for x in line_list_2nd_ele]
			print(''.join(sequence))
			
			haplotype = 0

