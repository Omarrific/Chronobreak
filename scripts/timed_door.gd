extends AnimatableBody2D

@onready var timer = $Timer


func _on_opening_body_entered(body):
	timer.start()
	set_collision_layer_value(1, false)


func _on_timer_timeout():
	set_collision_layer_value(1, true)

