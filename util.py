#!/usr/bin/env python3

import sys
import re

def scoped_format(s:str):
	"""
	Formats the given string as if the user had called str.format() passing in a dictionary
	with all the variables currently in scope. This allows syntax more akin to Ruby's formatting:
	
	name = "Brandon"
	print( scoped_format("My name is {name}") ) # prints "My name is Brandon" without 
												# needing to pass in 'name' or explicitly
												# call 'format()'
	"""
	#scope = dict(sys._getframe(1).f_locals, **globals())
	local = sys._getframe(1).f_locals
	
	return s.format(**scope)

eval_pattern = re.compile(r'(?<!\\){(.+?)(?<!\\)}')

def eval_format(s:str):
	local = sys._getframe(1).f_locals
	start = 0
	strlist = []
	for m in eval_pattern.finditer(s):
		strlist.append(s[start:m.start()])
		strlist.append(str(eval(m.group(1),globals(),local)))
		start = m.end()
	strlist.append(s[start:])
	return ''.join(strlist)
