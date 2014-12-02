from os import path
from time import time
from datetime import datetime


# Logger class
#  Handles where logs go, how they look like and provides
#  a standardized interface for a centralized log file.
# Use:
#  logobj = Logger("where/to/log.log","program name")
#  logobj.log("Message",<level>) #Where <level> is by def
#  ault 0 = INFO, 1 = WARN, 2 = SEVERE

class Logger():
	def __init__(self, loc, name):
		self.logFile = loc
		self.name = name
		# Log levels, 0 = "INFO", 1 = "WARN", 2 = "SEVERE"
		self.levels = ["INFO","WARN","SEVERE"]
		# Time format
		self.timeFormat = "%Y-%m-%d %H:%M:%S"
		# Format for the logs.
		# %T = time, %L = Level, %N = Name, %M = Message
		self.logFormat = "%T [%L] %N: %M\n"

	# self.log("Log message",<level>) -> creates log entry
	def log(self,message,level):
		assert level < len(self.levels)

		m = self.logFormat
		m = m.replace("%T",self.getTime()    )
		m = m.replace("%L",self.levels[level])
		m = m.replace("%N",self.name         )
		m = m.replace("%M",message           )

		self.out(m)

	# self.out("message") -> outputs to desired location
	def out(self, log):
		if self.logFile == "print":
			print(log)
		else:
			if path.isfile(self.logFile):
				file(self.logFile,"a").write(log)
			else:
				file(self.logFile,"w").write(log)

	# self.getTime() -> string defined by self.timeFormat
	def getTime(self):
		return datetime.fromtimestamp(time()).strftime(self.timeFormat)

