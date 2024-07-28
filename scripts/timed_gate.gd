extends AnimatableBody2D

@onready var timer = $Timer
@onready var activate = $closeGate/activate
@onready var label = $Node2D/Label

@export var gateTimer:int

var activated = false
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(gateTimer)
	handleCollision(false)

func _process(delta):
	label.text = String.num(timer.get_time_left(),2) + "s to be free"

func _on_activate_body_entered(body):
	if(!activated):
		activated = !activated
		timer.start()
		handleCollision(true)


func handleCollision(value):
	self.visible = value
	self.set_collision_layer_value(1,value)
	self.set_collision_layer_value(2,value)
	activate.set_collision_layer_value(1,value)
	activate.set_collision_layer_value(2,value)


func _on_timer_timeout():
	handleCollision(false)
