extends Control
var rot = 0.0;
var loadimg = load("res://images/screen.jpg")
var track1 = load("res://tracks/track1.jpg")
var track2 = load("res://tracks/track2.jpg")
var track3 = load("res://tracks/track3.jpg")
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
	if event.is_action_pressed("ui_accept") && r.get_node("lobby3D/lobby/play/playbtn").visible==true:
		car_num=get_tree().get_root().get_node("car_showcase").car_num
		get_tree().get_root().get_node("car_showcase").free()
		r.get_node("lobby3D/lobby/play").hide()
		r.get_node("lobby3D/lobby/UI").show()
		r.get_node("lobby3D/lobby/background").show()

func _on_settings_pressed():
	r.get_node("lobby3D/SettingsGUI").visible = true

func _on_backbtn_pressed():
	get_node("connect").hide()
	get_node("players").hide()
	r.get_node("lobby3D/SettingsGUI").visible = false
	get_node("UI").show()
	get_node("background/backbtn/background").modulate = Color(1.0,1.0,1.0)
	get_node("UI").modulate = Color(1.0,1.0,1.0)

func _on_track1_mouse_entered():
	get_node("background/backbtn/background").texture = track1


func _on_track2_mouse_entered():
	get_node("background/backbtn/background").texture = track2


func _on_track3_mouse_entered():
	get_node("background/backbtn/background").texture = track3


func start():
	var world = load("res://world.tscn").instance()
	var music = load("res://music/Winning the Race.ogg")
	get_tree().get_root().get_node("lobby3D/SettingsGUI/AudioStreamPlayer").stream = music
	get_tree().get_root().get_node("lobby3D/SettingsGUI/AudioStreamPlayer").play()
	get_tree().get_root().get_node("lobby3D/lobby").hide()
	get_tree().get_root().add_child(world)
	var newtrack
	if track==1:
		newtrack = load("res://tracks/1/track1.scn").instance()
	if track==2:
		newtrack = load("res://tracks/2/track2.scn").instance()
	if track==3:
		newtrack = load("res://tracks/3/track3.scn").instance()
	world.get_node("track").add_child(newtrack)
	var car_scene
	if car_num==1:
		car_scene = load("res://car/car.tscn")
	if car_num==2:
		car_scene = load("res://car/car2.tscn")
	
	var car = car_scene.instance()
	car.set_player_name("HugeGameArt")
	car.get_node("BODY").offline=true
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
	r.get_node("lobby3D/lobby/play").hide()
	r.get_node("lobby3D/lobby/UI").hide()
	r.get_node("lobby3D/lobby/background").hide()
	var car_showcase = load("res://car/car_showcase.tscn").instance()
	car_showcase.set_name("car_showcase")
	get_tree().get_root().add_child(car_showcase)
