import tests
def run(name):
	print("running {}...".format(name))
	getattr(tests, name).test()
