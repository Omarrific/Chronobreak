extends Node2D

@onready var end_level = $"General/CanvasLayer2/End Level"


@onready var player = $Player

var levelNumber = 1

func _ready():
	global.rewinding = false
	Engine.time_scale = 1
	player.animated_sprite.speed_scale = 1
	player.rewinding = false

func _on_end_flag_player_win():
	end_level.visible = true
