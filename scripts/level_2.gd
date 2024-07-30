extends Node2D

@onready var tile_map = $TileMap

@onready var trap_enable = $"world components/trapEnable"

@onready var end_level = $"General/CanvasLayer2/End Level"
@onready var missile_spawner = $"world components/DDR Trap/missiles/missile_spawner"
@onready var missile_spawner_2 = $"world components/DDR Trap/missiles/missile_spawner2"
@onready var missile_spawner_3 = $"world components/DDR Trap/missiles/missile_spawner3"
@onready var missile_spawner_4 = $"world components/DDR Trap/missiles/missile_spawner4"
@onready var missile_spawner_5 = $"world components/DDR Trap/missiles/missile_spawner5"
@onready var missile_spawner_6 = $"world components/DDR Trap/missiles/missile_spawner6"
@onready var missile_spawner_7 = $"world components/DDR Trap/missiles/missile_spawner7"
@onready var missile_spawner_8 = $"world components/DDR Trap/missiles/missile_spawner8"

var levelNumber = 2

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


func _on_end_flag_body_entered(body):
	end_level.visible = true
	


func _on_timer_timeout():
	missile_spawner.deactivate()
	missile_spawner_2.deactivate()
	missile_spawner_3.deactivate()
	missile_spawner_4.deactivate()
	missile_spawner_5.deactivate()
	missile_spawner_6.deactivate()
	missile_spawner_7.deactivate()
	missile_spawner_8.deactivate()
