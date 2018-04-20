extends Node
var check = false
var files = 0
var file=""
var main = preload("res://download/http.tscn")
var thisarray = []
var thisfolder = []


func _on_loading(loaded,total): 
	var percent
	if total != 0:
		percent = int(loaded*100/total)
	get_node("ProgressBar").set_value(percent)

func _on_loaded(result):
	var Data = File.new()
	Data.open("user://" + file, File.WRITE)
	Data.store_buffer(result)
	if check == false:
		next()
	else:
		Update(result)
	   
func Download(domain, address, name):
	file = name
	var directory = Directory.new();
	var FileExists = directory.file_exists("user://" + file)
	if check == true or not FileExists:
		get_node("ProgressBar").set_value(0)
		var http = main.instance()
		http.connect("loading",self,"_on_loading")
		http.connect("loaded",self,"_on_loaded")
		http.get(domain,address + name,443, true) #domain,url,port,useSSL
	else:
		next()
func Update(res):
	var string = res.get_string_from_utf8()
	string = string.replace(".:", "")
	string = string.replace(":", "")
	var array = string.split("\n./")
	array.remove(0)
	
	for line in array:
		var newarray = line.split("\n")#
		var folder = newarray[0]
		thisfolder.append("user://" + folder)
		var newdir = Directory.new()
		newarray.remove(0)
		newarray.remove(newarray.size()-1)
		for line2 in newarray:
			var dir = str(folder+"/"+line2)
			thisarray.append(dir)
	for d in thisfolder:
		var newdir = Directory.new()
		if not newdir.file_exists(d):
			newdir.make_dir(d)
	next()
	check = false
	
	
	
func next():
	if files < thisarray.size():
		files += 1
		get_node("ProgressBar/number").set_text(str(files) + " of " + str(thisarray.size()))
		get_node("ProgressBar/filename").set_text(str(thisarray[files-1]))
		Download("https://raw.githubusercontent.com","/HugeGameArtGD/Solus-Stunts-Assets/master/", str(thisarray[files-1]))
	else:
		get_node("ProgressBar/number").set_text("done")
		get_node("ProgressBar/filename").set_text("")
		init_game()

func get_platform():
	if OS.get_name()=="X11":
		return 1
	if OS.get_name()=="Windows":
		return 2
	if OS.get_name()=="OSX":
		return 3
	if OS.get_name()=="Android":
		return 4
	if OS.get_name()=="HTML5":
		return 5

func _ready():
	start()
	
func start():
	check = true
	Download("https://raw.githubusercontent.com","/HugeGameArtGD/Solus-Stunts-Assets/master/", "index.txt")

func init_game():
	var res = load("res://shader/screen_shaders.tscn").instance()
	res.set_name("shader")
	get_node("/root/gamestate").add_child(res)
	gamestate.goto_scene("res://lobby.tscn")

