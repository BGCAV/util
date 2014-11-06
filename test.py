#!/usr/bin/python
import os, sys, shutil, logger

def main():
	#Checks the length of arguements, exits if not enough
	if len(sys.argv) < 3:
		log.log("Not enough arguements: {}".format(sys.argv[1:]), 2)
		sys.exit()

	#Checks if source exists
	if os.path.exists(sys.argv[1]):
		log.log("{} exists, copying to {}...".format(sys.argv[1],sys.argv[2]),0)

	else:
		log.log("{} does not exist".format(sys.argv[1]),2)
		sys.exit()
	
	copy(sys.argv[1], sys.argv[2])

def copy(src,dst):
	if os.path.isfile(src):
		# Treat the copy as a file
		try:
			shutil.copy2(src,dst)

		except Exception, e:
			log.log(str(e),2)

	else:
		try:
			if os.path.exists(dst): shutil.rmtree(dst)
			shutil.copytree(src,dst)

		except Exception, e:
			log.log(str(e),2)

if __name__ == "__main__":
	log = logger.Logger("da.log",sys.argv[0])
	main()
