extends AnimatableBody2D

var isInside = false
var isOn = true

@onready var timer = $Timer

#func _ready():
	#set_collision_layer_value(1, false)

func _on_opening_body_entered(body):
	isInside = true

func _on_opening_body_exited(body):
	isInside = false
	
func _unhandled_input(event):
	if(event.is_action("interact") && isInside && isOn):
		set_collision_layer_value(1, false)
		self.visible = false
		isOn = false

		timer.start()

func _on_timer_timeout():
	set_collision_layer_value(1, true)
	self.visible = true
	isOn = true




