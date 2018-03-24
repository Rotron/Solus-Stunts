extends WorldEnvironment
var visible=1.0
var rot=0
var car_num=1
var car = preload("res://car/1/car.tscn").instance()
var car2 = preload("res://car/2/car2.tscn").instance()
var img_s
var col_s = Color(1.0,1.0,1.0)

func _ready():
	set_process(true)
	var intro = load("res://video/intro.webm")
	get_node("VideoPlayer").stream = intro
	get_node("VideoPlayer").play()

func get_platform():
	if OS.get_name()=="X11":
		return 1
	if OS.get_name()=="Windows":
		return 2
	if OS.get_name()=="Mac OSX":
		return 3
	if OS.get_name()=="Android":
		return 4
	if OS.get_name()=="HTML5":
		return 5
	if OS.get_name()=="iOS":
		return 6

func _process(delta):
	if has_node("VideoPlayer"):
		if not get_node("VideoPlayer").is_playing():
			if visible==1.0:
				var lobby
				if get_platform()<=3:
					lobby = load("res://lobby.tscn").instance()
				else:
					lobby = load("res://offline.tscn").instance()
				var mobile = load("res://car/mobile/mobile.tscn").instance()
				var settings = load("res://settings.tscn").instance()
				var car_showcase = load("res://car/showcase/car_showcase.tscn").instance()
				var dialog = load("res://dialog/bbcode/rich_text_bbcode.tscn").instance()
				var img = load("res://video/image.tscn").instance()
				mobile.set_name("mobile")
				dialog.set_name("Panel")
				settings.set_name("SettingsGUI")
				lobby.set_name("lobby")
				car_showcase.set_name("car_showcase")
				img.set_name("Sprite")
				add_child(mobile)
				add_child(lobby)
				add_child(settings)
				add_child(dialog)
				add_child(img)
				add_child(car_showcase)
				init(car)
				_load(car2)
				set_process_input(false)
				remove_child(get_node("VideoPlayer"))
	else:
		fade()

func update_background(img, col):
	var mesh = get_node("car_showcase/Camera/MeshInstance")
	var material = SpatialMaterial.new()
	material.flags_unshaded=true
	material.flags_transparent=true
	mesh.set_surface_material(0, material)
	if img != null:
		img_s = img
		mesh.get_surface_material(0).albedo_texture = img
	else:
		mesh.get_surface_material(0).albedo_texture = img_s
	if col != null:
		col_s = col
		mesh.get_surface_material(0).albedo_color = col
	else:
		mesh.get_surface_material(0).albedo_color = col_s
	
func fade():
	visible-=0.01
	get_node("Sprite").modulate=Color(1.0,1.0,1.0,visible)
	if visible<=0:
		set_process(false)
		remove_child(get_node("Sprite"))
		
		
func _load(c):
	c.gravity_scale = 0
	c.angular_velocity.y = 0.5
	get_node("car_showcase/ground").angular_velocity.y = 0.5
	c.set_player_name("")
	c.set_name("car_load")
	c.translation.y = 0.5
	c.translation.z = -5
	set_wheel_pos(c)
	add_child(c)

func init(c):
	c.gravity_scale = 0
	c.angular_velocity.y = 0.5
	get_node("car_showcase/ground").angular_velocity.y = 0.5
	c.set_player_name("")
	c.set_name("car")
	c.translation.y = 0.5
	c.translation.z = 0
	set_wheel_pos(c)
	add_child(c)

func set_wheel_pos(c):
	var ypos= 0.2
	c.get_node("left_front").translation.y = ypos
	c.get_node("left_rear").translation.y = ypos
	c.get_node("right_front").translation.y = ypos
	c.get_node("right_rear").translation.y = ypos

func start():
	remove_child(get_node("car_load"))
	set_process_input(true)

func _input(event):
	if Input.is_action_pressed("ui_right") and not event.is_echo():
		right()
	
	if Input.is_action_pressed("ui_left") and not event.is_echo():
		left()
		
func right():
	remove_child(get_node("car"))
	if car_num <= 1:
		car_num += 1
	else:
		car_num = 1
	
	if car_num == 1:
		init(car)
	if car_num == 2:
		init(car2)

func left():
	remove_child(get_node("car"))
	if car_num >= 2:
		car_num -= 1
	else:
		car_num = 2
	
	if car_num == 1:
		init(car)
	if car_num == 2:
		init(car2)