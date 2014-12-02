#!/usr/bin/python
import sys, test

if len(sys.argv) > 1:
	test.init(sys.argv)
else:
	print("nothing to do")
