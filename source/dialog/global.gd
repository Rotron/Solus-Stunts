extends Node

func write(dialog, dir):
	var file = File.new()
	file.open(dir, File.WRITE)
	var output = ""
	for line in dialog:
		output += "\n" + line
	output = output.right(1)
	file.store_string(output)
	file.close()
	print("file saved")

func read(dir):
	var file = File.new()
	if file.file_exists(dir):
		file.open(dir, File.READ)
		var input = file.get_as_text()
		var array = input.split("\n")
		print("file read")
		return array
	else:
		return
