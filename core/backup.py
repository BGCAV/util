#!/usr/bin/python
import os, sys, shutil, json, time, logger, config
log = logger.Logger(config.data['logFile'],__name__)

# Funtion:      getDates
# Parameters:   loc (type: str, desc: some file path)
# Description:  Gets files under location and returns dictionary
#               with files and dates
# Returns:      ages (type: dict)
def getDates(loc):
	ages = {}
	try:
		for f in os.listdir(loc):
			age = os.path.getctime(loc+f)
			ages[f] = age
	except Exception, e:
		log.log("The following exception has been caught: {}".format(e),2)

	return ages

# Function:     getNewest
# Parameters:   loc (type: str, desc: some file path)
# Description:  Gets the newest file in the path loc
# Returns:      new (type: tuple)
def getNewest(loc):
	new = ("",0)
	ages = getDates(loc)
	try:
		ageG = 0
		for f in ages:
			if ages[f] > ageG:
				ageG = ages[f]
				new = (f, ages[f])
	except Exception, e:
		log.log("The following exception has been caught: {}".format(e),2)
	
	return new

# Function:     getNewFiles
# Description:  Returns list of files to move from backupSrc to backupDst
# Returns:      tomove (type: list)
def getNewFiles():
	newest = getNewest(config.data['backupDst'])
	backups = getDates(config.data['backupSrc'])
	tomove = []
	for f in backups:
		if newest[1] < backups[f]:
			tomove.append(f)
	return tomove
# Procedure:    copy
# Parameters:   src (type: str, desc: some file path)
#               dst (type: str, desc: some file path)
# Description:  Copies src to dst
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

def backup():
	if os.path.exists(config.data['backupSrc']):
		log.log("{} exists, calulating backups to copy...".format(
		config.data['backupSrc']),0)

		newfiles = getNewFiles()
		log.log("found {} files to move".format(len(newfiles)),0)
		for f in newfiles:
			try:
				log.log("Copying {} to {}...".format(
				config.data['backupSrc'] + f, config.data['backupDst'] + f),0)
				copy(config.data['backupSrc'] + f, config.data['backupDst'] + f)
			except Exception, e:
				log.log("The following exception has been caught: {}".format(e),2)
	else:
		log.log("{} does not exist!".format(config.data['backupSrc']),2)
		sys.exit()
