extends WorldEnvironment
var visible=1.0

func _ready():
	set_process(true)
	var intro = load("res://video/intro.webm")
	get_node("VideoPlayer").stream = intro
	get_node("VideoPlayer").play()

func get_platform():
	if OS.get_name()=="X11":
		return 1
	if OS.get_name()=="Windows":
		return 2
	if OS.get_name()=="Mac OSX":
		return 3
	if OS.get_name()=="Android":
		return 4
	if OS.get_name()=="HTML5":
		return 5
	if OS.get_name()=="iOS":
		return 6

func _process(delta):
	if not get_node("VideoPlayer").is_playing():
		if visible==1.0:
			var lobby
			if get_platform()<=3:
				lobby = load("res://lobby.tscn").instance()
			else:
				lobby = load("res://offline.tscn").instance()
			var settings = load("res://settings.tscn").instance()
			var dialog = load("res://dialog/bbcode/rich_text_bbcode.scn").instance()
			var img = load("res://video/image.tscn").instance()
			dialog.set_name("Panel")
			settings.set_name("SettingsGUI")
			lobby.set_name("lobby")
			img.set_name("Sprite")
			add_child(lobby)
			add_child(settings)
			add_child(dialog)
			add_child(img)
		fade()
		
func fade():
	visible-=0.01
	get_node("Sprite").modulate=Color(1.0,1.0,1.0,visible)
	if visible<=0:
		set_process(false)
		remove_child(get_node("Sprite"))
		remove_child(get_node("VideoPlayer"))
