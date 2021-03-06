import os, logger, config, sys, time

log = logger.Logger(config.data['logFile'],__name__)

# Function:     readBackups
# Parameters:   loc (type: str, desc: backup path)
# Description:  Searches for backup files in given path 'loc'.
#               If files are found, they will be appended to dictionary
#               backups' with the format 'filename':'fileageinseconds'
# Returns:      backups (type: dict) or False
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

	if retVal is False:
		log.log("No backup files found.",1)
		sys.exit()
	
	return(retVal)

# Function:     checkBackups
# Parameters:   loc (type: str, desc: backup path)
#               maxage (type: int, desc: age in seconds of which a file is eligible to be purged)
# Description:  Checks if backups returned by readBackups are older than maxage
#               If a backup is older than maxage, it will be appended to list
#               'obselete_backups'
# Returns:      bselete_backups (type: list) or False
def checkBackups(loc, maxage):
	retVal = []
	backups = readBackups(loc)
	obselete_backups = []

	log.log("Checking for obselete backups.",0)
	for backup in backups:
		if backup <= maxage:
			obselete_backups.append(backup)

	if len(obselete_backups) > 0:
		log.log("The following backups are obselete and have been marked for deletion: {}".format(obselete_backups),0)
		retVal = obselete_backups
	else:
		log.log("No obselete backups found.",0)
	
	return(retVal)

# Procedure:    purgeBackups
# Parameters:   loc (type: str, desc: backup path)
#               maxage (type: int, desc: age in seconds of which a file is eligible to be purged)
# Description:  Gets a list of obselete backups from checkBackups and deletes them.
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
	loc = config.data['backupDst']

	if loc[-1] != "/": loc += "/"

	log.log("Purge age is set to {}".format(maxage),0)

	if not os.path.exists(loc):
		log.log("Backup path '{}' does not exist.".format(loc),2)
		sys.exit()

	maxage = time.time() - (maxage * 24 * 60 * 60) # Converts days to seconds
	
	purgeBackups(loc, maxage)
