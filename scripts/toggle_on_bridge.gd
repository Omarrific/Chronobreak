extends Node2D

@onready var bridgeCollider = $AnimatableBody2D/door
@onready var bridgeSprite = $AnimatableBody2D/Sprite2D
@onready var bridge = $AnimatableBody2D



var isInside = false

func _on_on_area_body_entered(body):
	isInside = true
	
func _on_on_area_body_exited(body):
	isInside = false

func _unhandled_input(event):
	if(event.is_action("interact") && isInside):
		handleBridge(true)

func _on_off_area_body_entered(body):
	handleBridge(false)
	
func handleBridge(value):
	bridge.set_collision_layer_value(1,value)
	bridge.visible = value
