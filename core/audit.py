import os, logger, config, sys

log = logger.Logger(config.data['logFile'],__name__)

# Function:		readBackups
# Parameters:	loc (type: str)
# Description:	Searches for backup files in given path 'loc'.
#				If files are found, will append them to dictionary 
#				'backups' with the format 'filename':'fileageinseconds'
# Returns:		backups (type: dict)
def readBackups(loc):
	retVal = False
	backups = {}
	log.log("Attempting to read backups from {}".format(loc),0)

	try:
		for f in os.listdir(loc):
			age = os.path.getctime(loc+f)
			backups[f] = age

		log.log("Backups successfully read.",0)
		retVal = backups
	except Exception, e:
		log.log("The follow exception has been caught: {}".format(e),2)
		sys.exit()

	assert retVal != False
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
		retVal = obselete_backups
	else:
		log.log("No obselete backups found.",0)

	return(retVal)


def purgeBackups(loc, maxage):
	obselete_backups = checkBackups(loc, maxage)	

	try:
		for f in os.listdir(loc):
			for backup in obselete_backups:
				if f == backup:
					os.remove(loc+f)
					log.log("Removing backup: {}".format(f),0)
	except Exception, e:
		log.log("The following exception has been caught: {}".format(e),2)
		sys.exit()


def audit():
	maxage = config.data['purgeAge']
	loc = config.data['backupDir']

	if loc[-1] != "/": loc += "/"

	log.log("Purge age is set to {}".format(maxage),0)

	if not os.path.exists(loc):
		log.log("Backup path '{}' does not exist.".format(loc),2)
		sys.exit()

	maxage = maxage * 24 * 60 * 60 # Converts days to seconds
	
	purgeBackups(loc, maxage)