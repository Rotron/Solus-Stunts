extends Area


func _ready():
	pass 



func _on_StaticBody2_body_entered(body):
	print("Game Over")
	get_tree().change_scene("res://lobby.tscn")


func _on_Area_body_entered(body):
	print("Game Over")
	get_tree().change_scene("res://lobby.tscn")
