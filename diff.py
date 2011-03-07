#!/usr/bin/env python3

import sys
import re
from util import eval_format as _f

from itertools import zip_longest

def main():
	if len(sys.argv) < 2:
		print('must specify 2 files')
		print(_f('usage: {sys.argv[0]} <file1> <file2>'))
		return
	
	f1, f2 = open(sys.argv[1]), open(sys.argv[2])
	
	compareFiles(f1, f2, [lambda a,b: b-a, lambda a,b: (a-b)/b])


	
def compareFiles(f1, f2, compares = [lambda a,b: b-a]):
	"""Compares the numbers in two files using one of several comparison methods."""
	#regex that matches a number
	np = re.compile(r'((\d+(\.\d*)?)|(\.\d+)([eE][+-]?\d+)?)')
	
	total = [0 for i in compares]
	count = 0
	
	for stra, strb in zip_longest(f1, f2):
		if stra == None:
			print(strb)
		elif strb == None:
			print(stra)
		else:
			itera, iterb = np.finditer(stra), np.finditer(strb)	
			for toka, tokb in zip_longest(itera, iterb):
				if toka == None:
					print(tokb.group(), end=' ')
				elif tokb == None:
					print(toka.group(), end=' ')
				else:
					print('<', end='')
					a, b = toka.group(), tokb.group()
					vals = [comp(float(a), float(b)) for comp in compares]
					for i in range(0,len(vals)):
						total[i] += vals[i]
					print(*["{0:.4}".format(val) for val in vals],sep='|', end='')
					count += 1
					print('> ', end='')
			print()
	averages = [t/count for t in total]
	print('---------\naverages:')
	print(*averages, sep=' | ')
 

if __name__ == "__main__":
	main()
	
