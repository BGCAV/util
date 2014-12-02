import os,test

def init(arg):
	tests = []
	for i in os.listdir("test/tests"):
		if i != "__init__.py" and i[-3:] == ".py":
			tests.append(i.split(".")[0])

	if arg[1] in tests:
		test.run(arg[1])
	else:
		print("Options are: {}".format(tests))
