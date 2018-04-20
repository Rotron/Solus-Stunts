extends Spatial

var num = 4
var time = 0.0
var car = null
func _ready():
	get_node("countdown/Timer").start()


func _input(event):
	if event.is_action_pressed("toggle_menu"):
		var settings = get_node("/root/lobby/SettingsGUI")
		settings.visible = !settings.visible
	if event.is_action_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())

func _on_Timer_timeout():
	num-=1
	if num == 3:
		get_node("countdown/number").texture_normal = gamestate.load_png(gamestate.b38)
	if num == 2:
		get_node("countdown/number").texture_normal = gamestate.load_png(gamestate.b37)
	if num == 1:
		get_node("countdown/number").texture_normal = gamestate.load_png(gamestate.b36)
	if num == 0:
		get_node("countdown/number").texture_normal = gamestate.load_png(gamestate.b39)
		car.set_physics_process(true)
	if num == -1:
		get_node("countdown/number").texture_normal = null
		num = 4
		get_node("countdown/Timer").stop()