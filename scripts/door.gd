extends AnimatableBody2D

#to open door
func _on_opening_body_entered(body):
	set_collision_layer_value(1, false)
