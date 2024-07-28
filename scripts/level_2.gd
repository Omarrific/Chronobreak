extends Node2D

@onready var tile_map = $TileMap

@onready var trap_enable = $"world components/trapEnable"
@onready var ddr_reset = $"ddr reset"

var enteredTrap = false

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map.set_layer_enabled(3,true)
	tile_map.set_layer_enabled(4,false)


func _on_trap_enable_body_entered(body):
	tile_map.set_layer_enabled(3,false)
	tile_map.set_layer_enabled(4,true)
	
	if(!enteredTrap):
		body.resetRewind()
		enteredTrap = !enteredTrap

	


func _on_ddr_reset_body_entered(body):
	body.resetRewind()
