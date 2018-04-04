extends Node
var check = false
var files = 0
var array = []
var file=""
var main = preload("res://download/http.tscn")

func _on_loading(loaded,total): 
	var percent
	if total != 0:
		percent = int(loaded*100/total)
	get_node("ProgressBar").set_value(percent)

func _on_loaded(result):
	var filename = file.split("/")
	var Data = File.new()
	Data.open("user://" + filename[filename.size()-1], File.WRITE)
	Data.store_buffer(result)
	if check == false:
		next()
	else:
		Update(result)
	   
func Download(domain, address, name):
	file = name
	var filename = name.split("/")
	var directory = Directory.new();
	var FileExists = directory.file_exists("user://" + filename[filename.size()-1])
	print(str(FileExists)+filename[filename.size()-1]+str(check))
	if check == true or not FileExists:
		get_node("ProgressBar").set_value(0)
		var http = main.instance()
		http.connect("loading",self,"_on_loading")
		http.connect("loaded",self,"_on_loaded")
		http.get(domain,address + name,443, true) #domain,url,port,useSSL
	else:
		next()
		print("bad"+str(name))
func Update(res):
	var string = res.get_string_from_utf8()
	string = string.replace(" ", "")
	string = string.replace("[", "")
	string = string.replace("]", "")
	array = string.split(",")
	check = false
	next()
	
func next():
	if files < array.size():
		files += 1
		get_node("ProgressBar/number").set_text(str(files) + " of " + str(array.size()))
		get_node("ProgressBar/filename").set_text(str(array[files-1]))
		Download("https://raw.githubusercontent.com","/HugeGameArtGD/Solus-Stunts/master/media/", str(array[files-1]))
	else:
		get_node("ProgressBar/number").set_text("done")
		get_node("ProgressBar/filename").set_text("")
	
	
	
func _ready():
	start()
	
func start():
	check = true
	Download("https://raw.githubusercontent.com","/HugeGameArtGD/Solus-Stunts/master/media/", "index.txt")