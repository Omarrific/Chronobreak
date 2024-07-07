extends AnimatableBody2D

@onready var timer = $Timer


func _on_opening_body_entered(body):
	timer.start()
	set_collision_layer_value(1, false)
	self.visible = false
	print("hi")



func _on_timer_timeout():
	set_collision_layer_value(1, true)
	self.visible = true

