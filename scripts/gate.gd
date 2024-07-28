extends AnimatableBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	handleCollision(false)
	
func handleCollision(value):
	self.visible = value
	self.set_collision_layer_value(1,value)
	self.set_collision_layer_value(2,value)
	
func _on_activate_body_entered(body):
	handleCollision(true)
