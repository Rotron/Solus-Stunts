extends Spatial
var three = preload("res://ui/countdown/3.png")
var two = preload("res://ui/countdown/2.png")
var one = preload("res://ui/countdown/1.png")
var go = preload("res://ui/countdown/go.png")
var num = 4
var time = 0.0
var car = null
func _ready():
	get_node("countdown/Timer").start()


func _on_Timer_timeout():
	num-=1
	if num == 3:
		get_node("countdown/number").texture_normal = three
	if num == 2:
		get_node("countdown/number").texture_normal = two
	if num == 1:
		get_node("countdown/number").texture_normal = one
	if num == 0:
		get_node("countdown/number").texture_normal = go
		car.set_physics_process(true)
	if num == -1:
		get_node("countdown/number").texture_normal = null
		num = 4
		get_node("countdown/Timer").stop()