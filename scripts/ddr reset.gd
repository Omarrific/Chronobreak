extends Area2D



func _on_body_entered(body):
	body.resetRewind()
	body.respawn_position = self.global_position
	self.set_collision_layer_value(1,false)
	self.set_collision_mask_value(2,false)
