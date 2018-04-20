extends Control

onready var l = $"/root/lobby"
func _ready():
	get_node("steering/left").normal = gamestate.load_png(gamestate.b3)
	get_node("steering/right").normal= gamestate.load_png(gamestate.b3)
	get_node("speed/gas").normal = gamestate.load_png(gamestate.b7)
	get_node("speed/brake").normal = gamestate.load_png(gamestate.b4)

func _on_left_pressed():
	if l.is_processing_input()==true:
		l.left()

func _on_right_pressed():
	if l.is_processing_input()==true:
		l.right()

func _on_gas_pressed():
	pass


func _on_brake_pressed():
	pass
