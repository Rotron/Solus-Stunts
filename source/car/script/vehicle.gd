extends VehicleBody

const MAX_SPEED = 50
const STEER_SPEED = 1
const STEER_LIMIT = 0.4

export var force = 1500

var braking_force_mult = 4
var offset

var steer_angle = 0
var steer_target = 0
var predicted_steer = 0

var speed
var speed_int = 0
var speed_kph = 0

var forward_vec
var reverse
var time = 0
func _physics_process(delta):
	time += delta
	speed = get_linear_velocity().length()
	if (speed > 35):
		STEER_LIMIT = 0.2
		STEER_SPEED = 0.5
	elif (speed > 28):
		STEER_LIMIT = 0.4
		STEER_SPEED = 0.5
	elif (speed > 15):
		STEER_LIMIT = 0.5
		STEER_SPEED = 0.5
	elif (speed > 5):
		STEER_LIMIT = 0.75
		STEER_SPEED = 0.5
	else:
		STEER_LIMIT = 1
		STEER_SPEED = 1
	
	get_node("info/fps").set_text(str(Engine.get_frames_per_second()) + " fps")
	get_node("info/v").set_text(str(round(speed*3.6)) + " kph")
	var minutes = int(time/60)
	var seconds = int(time) - minutes * 60
	if minutes == 0:
		get_node("info/time").set_text(str(seconds) + "s")
	else:
		get_node("info/time").set_text(str(minutes) + "m " + str(seconds) + "s")
	
	
	get_node("cambase/Camera").make_current()
	
	if Input.is_action_pressed("ui_left") or $"/root/lobby/mobile/steering/left".is_pressed():
		steer_target = STEER_LIMIT
	elif Input.is_action_pressed("ui_right") or $"/root/lobby/mobile/steering/right".is_pressed():
		steer_target = -STEER_LIMIT
	else:
		steer_target = 0
	
	if Input.is_action_pressed("ui_up") or $"/root/lobby/mobile/speed/gas".is_pressed():
		if (speed < MAX_SPEED):
			set_engine_force(force)
		else:
			set_engine_force(0)
	else:
		if (speed > 3):
			set_engine_force(-force/4)
		else:
			set_engine_force(0)
	
	if Input.is_action_pressed("ui_down") or $"/root/lobby/mobile/speed/brake".is_pressed():
		if (speed > 5):
			set_brake(1)
			set_engine_force(-force*braking_force_mult)
		else:
			set_brake(0.0)
			set_engine_force(-force)
		
	else:
		set_brake(0.0)
	
		
	if (steer_target < steer_angle):
		steer_angle -= STEER_SPEED*delta
		if (steer_target > steer_angle):
			steer_angle = steer_target
	elif (steer_target > steer_angle):
		steer_angle += STEER_SPEED*delta
		if (steer_target < steer_angle):
			steer_angle = steer_target
	set_steering(steer_angle)
	
	var forward_vec = get_global_transform().xform(Vector3(0, 1.5, 2))-get_global_transform().origin
	if (get_linear_velocity().dot(forward_vec) > 0):
		reverse = false
	else:
		reverse = true

	
func set_player_name(new_name):
	get_node("Viewport/Nametag/Label").set_text(new_name)
	update()

func update():
	var tex = get_node("Viewport").get_texture()
	var mesh = get_node("MeshInstance")
	var material = SpatialMaterial.new()
	material.flags_unshaded=true
	material.flags_transparent=true
	mesh.set_surface_material(0, material)
	mesh.get_surface_material(0).albedo_texture = tex

func _ready():
	set_physics_process(false)