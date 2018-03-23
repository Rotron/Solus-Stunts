extends HBoxContainer

var player_labels = {}

func _process(delta):
	pass

sync func increase_score(for_who):
	assert(for_who in player_labels)
	var pl = player_labels[for_who]
	pl.score += 1
	pl.label.set_text(pl.name + "\n" + str(pl.score))

func add_player(id, new_player_name):
	var l = Label.new()
	l.set_align(Label.ALIGN_CENTER)
	l.set_text(new_player_name + "\n" + "0")
	l.set_h_size_flags(SIZE_EXPAND_FILL)
	var font = DynamicFont.new()
	font.set_size(18)
	font.set_font_data(load("res://font/carlito/google-crosextrafonts-carlito-20130920/Carlito-Bold.ttf"))
	l.add_font_override("font", font)
	add_child(l)

	player_labels[id] = { name = new_player_name, label = l, score = 0 }

func _ready():
	get_node("../winner").hide()
	set_process(true)

func _on_exit_game_pressed():
	gamestate.end_game()
