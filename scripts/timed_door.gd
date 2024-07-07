extends AnimatableBody2D

@onready var timer = $Timer

@export var rewindOnly:bool

func _on_opening_body_entered(body):
	timer.start()
	set_collision_layer_value(1, false)
	self.visible = false


func _on_timer_timeout():
	set_collision_layer_value(1, true)
	self.visible = true

