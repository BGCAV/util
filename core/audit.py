import os, logger, config, sys

log = logger.Logger(config.data,__name__)
def readBackups(loc):
	retVal = False
	backups = {}
	log.log("Attempting to read backups from {}".format(loc),0)

	try:
		for f in os.listdir(loc):
			age = os.path.getctime(f)
			backups[f] = age

		log.log("Backups successfully read.",0)
		retVal = backups
	except:
		log.log("The follow exception has been caught: ")

	return(retVal)


def checkBackups(loc, maxage):
	retVal = False
	backups = readBackups(loc)
	obselete_backups = []

	log.log("Checking for obselete backups.",0)
	for backup in backups:
		if backup >= maxage:
			obselete_backups.append(backup)

	if len(obselete_backups) > 0:
		log.log("The following backups are obselete and have been marked for deletion: {}".format(obselete_backups),0)
	else:
		log.log("No obselete backups found.",0)
