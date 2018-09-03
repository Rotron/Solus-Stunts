extends Area
var ROUND = 1

func _ready():
	pass 



func _on_StaticBody2_body_entered(_body):
	print("Game Over")
	get_tree().change_scene("res://lobby.tscn")


func _on_Area_body_entered(_body):
	print("Game Over")
	get_tree().change_scene("res://lobby.tscn")




func _on_goal2_body_entered(body):
	if ROUND < 3:
		ROUND += 1
		$"/root/lobby/world/round".text="round " + str(ROUND) + " of 3"
	else:
		get_tree().change_scene("res://lobby.tscn")


func _on_goal_body_entered(body):
	if ROUND < 3:
		ROUND += 1
		$"/root/lobby/world/round".text="round " + str(ROUND) + " of 3"
	else:
		get_tree().change_scene("res://lobby.tscn")
