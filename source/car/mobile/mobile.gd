extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var l
func _ready():
	l = get_tree().get_root().get_node("lobby3D")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_left_pressed():
	if l.is_processing_input()==true:
		l.left()


func _on_right_pressed():
	if l.is_processing_input()==true:
		l.right()
