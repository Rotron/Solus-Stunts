extends Spatial

var rot=0
var car_num=1
var car = preload("res://car/car.tscn")
var car2 = preload("res://car/car2.tscn")
var vehicle
func _ready():
	set_process_input(true)
	vehicle = car.instance()
	init()

func init():
	vehicle.set_player_name("")
	vehicle.set_name("car")
	vehicle.set_translation(Vector3(0,0.25,0))
	get_node("ground").angular_velocity.y = 0.5
	add_child(vehicle)

func _input(event):
	if Input.is_action_pressed("ui_right") and not event.is_echo():
		remove_child(get_node("car"))
		if car_num <= 1:
			car_num += 1
		else:
			car_num = 1
		
		if car_num == 1:
			vehicle = car.instance()
		if car_num == 2:
			vehicle = car2.instance()
		init()
	if Input.is_action_pressed("ui_left") and not event.is_echo():
		remove_child(get_node("car"))
		if car_num >= 2:
			car_num -= 1
		else:
			car_num = 2
		
		if car_num == 1:
			vehicle = car.instance()
		if car_num == 2:
			vehicle = car2.instance()
		init()

func _physics_process(delta):
	vehicle.get_node("BODY").linear_velocity = Vector3(0,0,0)
	