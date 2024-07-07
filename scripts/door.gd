extends AnimatableBody2D

@export var rewindOnly:bool

#to open door
func _on_opening_body_entered(body):
	if(!rewindOnly):
		set_collision_layer_value(1, false)
		self.visible = false
	else:
		if(body.rewinding):
			set_collision_layer_value(1, false)
			self.visible = false
		

