extends Control
var rot = 0.0;
var loadimg = preload("res://images/screen.jpg")
func _ready():
	# Called every time the node is added to the scene.
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")
	set_process_input(true)

func _input(event):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().free()

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
	# refresh_lobby() gets called by the player_list_changed signal

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
	gamestate.begin_game()

func _on_start_pressed():
	get_tree().get_root().get_node("lobby3D/lobby").hide()
	var music = load("res://music/Winning the Race.ogg")
	get_node("AudioStreamPlayer").stream = music
	get_node("AudioStreamPlayer").play()
	now()
	
	



func _on_single_pressed():
	pass


func _on_multi_pressed():
	get_node("connect").show()
	get_node("backbtn/background").modulate = Color(0.5,0.5,0.5)
	get_node("UI").modulate = Color(0.5,0.5,0.5)
	


func _on_settings_pressed():
	pass # replace with function body


func _on_start_button_down():
	get_node("backbtn/background").texture = loadimg
	get_node("UI").hide()
	get_node("backbtn/background").z_index = 1


func _on_backbtn_pressed():
	get_node("connect").hide()
	get_node("players").hide()
	get_node("UI").show()
	get_node("backbtn/background").modulate = Color(1.0,1.0,1.0)
	get_node("UI").modulate = Color(1.0,1.0,1.0)
	
