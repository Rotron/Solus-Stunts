extends Control
var rot = 0.0;
var loadimg = load("res://images/screen.jpg")
var track1 = load("res://tracks/1/preview/track1.jpg")
var track2 = load("res://tracks/2/preview/track2.jpg")
var track3 = load("res://tracks/3/preview/track3.jpg")
var track=0
var car_num=1
onready var r = get_tree().get_root()
func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("toggle_menu"):
		var settings = r.get_node("lobby3D/SettingsGUI")
		settings.visible = !settings.visible
	if event.is_action_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())

func _on_settings_pressed():
	r.get_node("lobby3D/SettingsGUI").visible = true

func _on_backbtn_pressed():
	get_node("connect").hide()
	get_node("players").hide()
	r.get_node("lobby3D/SettingsGUI").visible = false
	get_node("UI").show()
	r.get_node("lobby3D").update_background(null, Color(1.0,1.0,1.0))
	get_node("UI").modulate = Color(1.0,1.0,1.0)

func _on_track1_mouse_entered():
	r.get_node("lobby3D").update_background(track1, null)


func _on_track2_mouse_entered():
	r.get_node("lobby3D").update_background(track2, null)

func _on_track3_mouse_entered():
	r.get_node("lobby3D").update_background(track3, null)


func start():
	car_num=r.get_node("lobby3D").car_num
	var world = load("res://world.tscn").instance()
	var music = load("res://music/Winning the Race.ogg")
	get_tree().get_root().get_node("lobby3D/SettingsGUI/AudioStreamPlayer").stream = music
	get_tree().get_root().get_node("lobby3D/SettingsGUI/AudioStreamPlayer").play()
	get_tree().get_root().get_node("lobby3D/lobby").hide()
	get_tree().get_root().get_node("lobby3D/Panel").free()
	get_tree().get_root().get_node("lobby3D").set_process_input(false)
	get_tree().get_root().get_node("lobby3D/car_showcase").free()
	get_tree().get_root().get_node("lobby3D/car").free()
	get_tree().get_root().add_child(world)
	var newtrack
	if track==1:
		newtrack = load("res://tracks/1/track1.tscn").instance()
	if track==2:
		newtrack = load("res://tracks/2/track2.tscn").instance()
	if track==3:
		newtrack = load("res://tracks/3/track3.tscn").instance()
	world.get_node("track").add_child(newtrack)
	
	var car_scene
	if car_num==1:
		car_scene = load("res://car/1/car.tscn")
	if car_num==2:
		car_scene = load("res://car/2/car2.tscn")
	var car = car_scene.instance()
	car.set_player_name("HugeGameArt")
	car.offline=true
	world.car = car
	world.get_node("vehicles").add_child(car)
func _on_track1_pressed():
	track=1
	start()


func _on_track2_pressed():
	track=2
	start()


func _on_track3_pressed():
	track=3
	start()

func _on_playbtn_pressed():
	get_node("play").hide()
	r.get_node("lobby3D").start()
