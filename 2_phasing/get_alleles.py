import sys


origchar = open(sys.argv[1], 'r')
out = open(sys.argv[2], 'w+')

for line in origchar:
	line = list(line.strip('\n'))
	for i in range(0,len(line),2):
		out.write(line[i]+line[i+1]+'\n')

origchar.close()
out.close()


