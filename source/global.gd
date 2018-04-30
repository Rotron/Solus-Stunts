extends Node
# load ressource
#index.txt
#./img:
var Broderick = "user://img/Broderick.png"
#./music:
var ArcLight = "user://music/ArcLight.ogg"
var SkiessiC64 = "user://music/Skiessi-C64.ogg"
var TacticalPursuit = "user://music/TacticalPursuit.ogg"
var Vilified = "user://music/Vilified.ogg"
var WinningtheRace = "user://music/WinningtheRace.ogg"
#./ui: (from 1 to 39)
var b1 = "user://ui/1.png"
var b2 = "user://ui/2.png"
var b3 = "user://ui/3.png"
var b4 = "user://ui/4.png"
var b5 = "user://ui/5.png"
var b6 = "user://ui/6.png"
var b7 = "user://ui/7.png"
var b8 = "user://ui/8.png"
var b9 = "user://ui/9.png"
var b10 = "user://ui/10.png"
var b11 = "user://ui/11.png"
var b12 = "user://ui/12.png"
var b13 = "user://ui/13.png"
var b14 = "user://ui/14.png"
var b15 = "user://ui/15.png"
var b16 = "user://ui/16.png"
var b17 = "user://ui/17.png"
var b18 = "user://ui/18.png"
var b19 = "user://ui/19.png"
var b20 = "user://ui/20.png"
var b21 = "user://ui/21.png"
var b22 = "user://2ui/2.png"
var b23 = "user://ui/23.png"
var b24 = "user://ui/24.png"
var b25 = "user://ui/25.png"
var b26 = "user://ui/26.png"
var b27 = "user://ui/27.png"
var b28 = "user://ui/28.png"
var b29 = "user://ui/29.png"
var b30 = "user://ui/30.png"
var b31 = "user://ui/31.png"
var b32 = "user://ui/32.png"
var b33 = "user://ui/33.png"
var b34 = "user://ui/34.png"
var b35 = "user://ui/35.png"
var b36 = "user://ui/36.png"
var b37 = "user://ui/37.png"
var b38 = "user://ui/38.png"
var b39 = "user://ui/39.png"

# end index.txt

var rot = 0.0
const DEFAULT_PORT = 10567
const MAX_PEERS = 12
var player_name = ""
var track = 1
var car_num = 1
var index = 0
var players = {}
var loader
var wait_frames
var time_max = 100 # msec
var current_scene

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

func _player_connected(id):
	pass

func _player_disconnected(id):
	if (get_tree().is_network_server()):
		if (has_node("/root/world3D/world2")):
			emit_signal("game_error", "Player " + players[id] + " disconnected")
			end_game()
		else:
			unregister_player(id)
			for p_id in players:
				rpc_id(p_id, "unregister_player", id)

func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id(), player_name)
	emit_signal("connection_succeeded")

func _server_disconnected():
	emit_signal("game_error", "Server disconnected")
	end_game()

func _connected_fail():
	get_tree().set_network_peer(null)
	emit_signal("connection_failed")

remote func register_player(id, new_player_name):
	if (get_tree().is_network_server()):
		rpc_id(id, "register_player", 1, player_name) 
		for p_id in players:
			rpc_id(id, "register_player", p_id, players[p_id])
			rpc_id(p_id, "register_player", id, name)
	players[id] = new_player_name
	emit_signal("player_list_changed")

remote func unregister_player(id):
	players.erase(id)
	emit_signal("player_list_changed")

remote func pre_start_game(tr,carn):
	var world = load("res://world.tscn").instance()
	#var music = load("res://music/Winning the Race.ogg")
	#get_tree().get_root().get_node("lobby3D/SettingsGUI/AudioStreamPlayer").stream = music
	#get_tree().get_root().get_node("lobby3D/SettingsGUI/AudioStreamPlayer").play()
	get_tree().get_root().get_node("lobby/play").free()
	get_tree().get_root().get_node("lobby/settings").free()
	get_tree().get_root().get_node("lobby/UI").free()
	get_tree().get_root().get_node("lobby/connect").free()
	get_tree().get_root().get_node("lobby/players").free()
	
	#get_tree().get_root().get_node("lobby/Panel").free()
	get_tree().get_root().get_node("lobby").set_process_input(false)
	get_tree().get_root().get_node("lobby/car_showcase").free()
	get_tree().get_root().get_node("lobby/car").hide()
	get_tree().get_root().add_child(world)
	var newtrack
	if tr == 1:
		newtrack = load("res://tracks/1/track1.tscn").instance()
	if tr == 2:
		newtrack = load("res://tracks/2/track2.tscn").instance()
	if tr == 3:
		newtrack = load("res://tracks/3/track3.tscn").instance()
	world.get_node("track").add_child(newtrack)
	
	var car_scene
	if carn==1:
		car_scene = load("res://car/1/car.tscn")
	if carn==2:
		car_scene = load("res://car/2/car2.tscn")
	if carn==3:
		car_scene = load("res://car/3/car3.tscn")
	var car = car_scene.instance()
	car.set_name(str(get_tree().get_network_unique_id()))
	car.set_network_master(get_tree().get_network_unique_id())
	car.set_player_name(player_name)
	world.car = car
	world.get_node("vehicles").add_child(car)
	world.get_node("score").add_player(get_tree().get_network_unique_id(), player_name)
	for pn in players:
		car = car_scene.instance()
		car.set_name(str(pn))
		car.set_network_master(pn)
		car.set_player_name(players[pn])
		world.get_node("vehicles").add_child(car)
		world.get_node("score").add_player(pn, players[pn])
	if (not get_tree().is_network_server()):
		rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())
	elif players.size() == 0:
		post_start_game()

remote func post_start_game():
	get_tree().set_pause(false)

var players_ready = []

remote func ready_to_start(id):
	assert(get_tree().is_network_server())

	if (not id in players_ready):
		players_ready.append(id)

	if (players_ready.size() == players.size()):
		for p in players:
			rpc_id(p, "post_start_game")
		post_start_game()

func host_game(new_player_name):
	player_name = new_player_name
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)

func join_game(ip, new_player_name):
	player_name = new_player_name
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)

func get_player_list():
	return players.values()

func get_player_name():
	return player_name

func begin_game():
	assert(get_tree().is_network_server())
	for p in players:
		rpc_id(p, "pre_start_game", track, car_num)
	pre_start_game(track, car_num)

func end_game():
	if (has_node("/root/world3D/world2")):
		get_node("/root/world3D/world2").queue_free()
	emit_signal("game_ended")
	players.clear()
	get_tree().set_network_peer(null)

func networking():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _process(time):
	if loader == null:
		set_process(false)
		return
	if wait_frames > 1: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = loader.poll()
		if err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			get_node("/root/gamestate/video").queue_free()
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			show_error()
			loader = null
			break

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()

func set_new_scene(scene_resource):
    current_scene = scene_resource.instance()
    get_node("/root").add_child(current_scene)



func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		show_error()
		return
	set_process(true)
	current_scene.queue_free() # get rid of the old scene
	wait_frames = 1

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	set_process(false)

func load_ogg(file):
	var ogg_file = File.new()
	ogg_file.open(file, File.READ)
	var bytes = ogg_file.get_buffer(ogg_file.get_len())
	var stream = AudioStreamOGGVorbis.new()
	stream.data = bytes
	ogg_file.close()
	return stream

func load_jpg(file):
	var jpg_file = File.new()
	jpg_file.open(file, File.READ)
	var bytes = jpg_file.get_buffer(jpg_file.get_len())
	var img = Image.new()
	var data = img.load_jpg_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	jpg_file.close()
	return imgtex

func load_png(file):
	var png_file = File.new()
	png_file.open(file, File.READ)
	var bytes = png_file.get_buffer(png_file.get_len())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	png_file.close()
	return imgtex
func show_error():
	print("error")
	
	
