extends Control

func _ready():
	pass

func set_player_name(new_name):
	get_node("Label").set_text(new_name)
