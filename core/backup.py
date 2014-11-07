#!/usr/bin/python
import os, sys, shutil, json, time, logger, config
log = logger.Logger(config.data['logFile'],__name__)

def backup():
	if os.path.exists(config.data['backupLoc']):
		log.log("{} exists, copying {} to {}".format(
		config.data['backupLoc'],config.data['backupLoc'],getDstName(config.data['backupDir'])),0)
		copy(config.data['backupLoc'], getDstName(config.data['backupDir']))
	else:
		log.log("{} does not exist!".format(config.data['backupLoc']),2)
		sys.exit()

def getDstName(dst):
	if dst[-1] != "/":
		dst += "/"

	return dst + time.strftime(config.data['backupFormat'])

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

