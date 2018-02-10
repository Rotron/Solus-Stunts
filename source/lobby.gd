extends Control
var rot = 0.0;
var loadimg = preload("res://images/screen.jpg")
var track1 = preload("res://tracks/track1.jpg")
var track2 = preload("res://tracks/track2.jpg")
var track3 = preload("res://tracks/track3.jpg")
var track = 0
func _ready():
	# Called every time the node is added to the scene.
	var settings = get_tree().get_root().get_node("lobby3D/SettingsGUI")
	settings.visible = !settings.visible
	
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("toggle_menu"):
		var settings = get_tree().get_root().get_node("lobby3D/SettingsGUI")
		settings.visible = !settings.visible
	if event.is_action_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())

func _on_host_pressed():
	if (get_node("connect/name").text == ""):
		get_node("connect/error_label").text="Invalid name!"
		return

	get_node("connect").hide()
	get_node("players").show()
	get_node("connect/error_label").text=""

	var player_name = get_node("connect/name").text
	gamestate.host_game(player_name)
	refresh_lobby()

func _on_join_pressed():
	if (get_node("connect/name").text == ""):
		get_node("connect/error_label").text="Invalid name!"
		return

	var ip = get_node("connect/ip").text
	if (not ip.is_valid_ip_address()):
		get_node("connect/error_label").text="Invalid IPv4 address!"
		return

	get_node("connect/error_label").text=""
	get_node("connect/host").disabled=true
	get_node("connect/join").disabled=true

	var player_name = get_node("connect/name").text
	gamestate.join_game(ip, player_name)

func _on_connection_success():
	get_node("connect").hide()
	get_node("players").show()

func _on_connection_failed():
	get_node("connect/host").disabled=false
	get_node("connect/join").disabled=false
	get_node("connect/error_label").set_text("Connection failed.")

func _on_game_ended():
	show()
	get_node("connect").show()
	get_node("players").hide()
	get_node("connect/host").disabled=false
	get_node("connect/join").disabled

func _on_game_error(errtxt):
	get_node("error").dialog_text=errtxt
	get_node("error").popup_centered_minsize()

func refresh_lobby():
	var players = gamestate.get_player_list()
	players.sort()
	get_node("players/list").clear()
	get_node("players/list").add_item(gamestate.get_player_name() + " (You)")
	for p in players:
		get_node("players/list").add_item(p)
	get_node("players/start").disabled=not get_tree().is_network_server()

func now():
	gamestate.begin_game(track)

func _on_start_pressed():
	get_tree().get_root().get_node("lobby3D/lobby").hide()
	var music = load("res://music/Winning the Race.ogg")
	get_tree().get_root().get_node("lobby3D/SettingsGUI/AudioStreamPlayer").stream = music
	get_tree().get_root().get_node("lobby3D/SettingsGUI/AudioStreamPlayer").play()
	now()

func multiplayer_dialog():
	get_node("connect").show()
	get_node("background/backbtn/background").modulate = Color(0.5,0.5,0.5)
	get_node("UI").modulate = Color(0.5,0.5,0.5)

func _on_settings_pressed():
	get_tree().get_root().get_node("lobby3D/SettingsGUI").visible = true

func _on_start_button_down():
	get_node("background/backbtn/background").texture = loadimg
	get_node("background/backbtn/background").z_index = 3

func _on_backbtn_pressed():
	get_node("connect").hide()
	get_node("players").hide()
	get_tree().get_root().get_node("lobby3D/SettingsGUI").visible = false
	get_node("UI").show()
	get_node("background/backbtn/background").modulate = Color(1.0,1.0,1.0)
	get_node("UI").modulate = Color(1.0,1.0,1.0)

func _on_single_button_down():
	_on_start_button_down()


func _on_track1_mouse_entered():
	get_node("background/backbtn/background").texture = track1


func _on_track2_mouse_entered():
	get_node("background/backbtn/background").texture = track2


func _on_track3_mouse_entered():
	get_node("background/backbtn/background").texture = track3


func _on_track1_pressed():
	track=1
	multiplayer_dialog()


func _on_track2_pressed():
	track=2
	multiplayer_dialog()


func _on_track3_pressed():
	track=3
	multiplayer_dialog()

func _on_playbtn_pressed():
	get_tree().get_root().get_node("lobby3D/lobby/settings").hide()
	get_tree().get_root().get_node("lobby3D/lobby/play").hide()
	get_tree().get_root().get_node("lobby3D/lobby/UI").show()
