import backup,config,logger

log = logger.Logger(config.data['logFile'],__name__)

def start():
	log.log("Starting backup...",0)
	backup.backup()

