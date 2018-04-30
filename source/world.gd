extends Spatial
var b38 = preload("res://assets/ui/38.png")
var b37 = preload("res://assets/ui/37.png")
var b36 = preload("res://assets/ui/36.png")
var b39 = preload("res://assets/ui/39.png")
var num = 4
var time = 0.0
var car = null
func _ready():
	get_node("countdown/Timer").start()


func _input(event):
	if event.is_action_pressed("return"):
		get_tree().change_scene("res://lobby.tscn")
	if event.is_action_pressed("toggle_menu"):
		var settings = get_node("/root/lobby/SettingsGUI")
		settings.visible = !settings.visible
	if event.is_action_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())

func _on_Timer_timeout():
	num-=1
	if num == 3:
		get_node("countdown/number").texture_normal = b38
	if num == 2:
		get_node("countdown/number").texture_normal = b37
	if num == 1:
		get_node("countdown/number").texture_normal = b36
	if num == 0:
		get_node("countdown/number").texture_normal = b39
		car.set_physics_process(true)
	if num == -1:
		get_node("countdown/number").texture_normal = null
		num = 4
		get_node("countdown/Timer").stop()