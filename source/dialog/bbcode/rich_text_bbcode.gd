extends Panel
var line = ""
var code = ""
var l = 0

func start():
	show()
	line = dialog.read("res://dialog/dialog")
	code = ""
	l = 0
	for n in line:
		code += n + "\n"
	$"Label".visible_characters = 0
	_on_Button_pressed()
	$"Timer".start()

func _ready():
	pass

func _on_Button_pressed():
	if $"Timer".is_stopped():
		if l <= line.size()-1:
			$"Label".set_bbcode(line[l])
			if l == line.size()-1:
				get_node("Button").text = "OK"
			l += 1
			$"Label".visible_characters = 0
			$"Timer".start()
		else:
			hide()
			get_tree().get_root().get_node("lobby3D/lobby/play/playbtn").show()
	else:
		$"Label".visible_characters = $"Label".get_total_character_count()
		


func _on_Timer_timeout():
	if $"Label".get_visible_characters() < $"Label".get_total_character_count():
		$"Label".visible_characters += 1
	else:
		$"Timer".stop()


func _on_Label_meta_clicked( meta ):
	OS.shell_open(meta)
