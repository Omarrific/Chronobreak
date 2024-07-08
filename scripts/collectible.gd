extends Node2D

@export var collectibleNum:int
@export var rewindOnly: bool

@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if(global.collectibles.has(collectibleNum)):
		queue_free()
	if(rewindOnly):
		handle_collision(false)

func _process(delta):
	if(rewindOnly):
		if(global.rewinding):
			handle_collision(true)
		else:
			handle_collision(false)

func handle_collision(value):
	self.visible = value
	area.set_collision_layer_value(1, value)


func _on_area_2d_body_entered(body):
	global.currCollectibles.append(collectibleNum)
	print(global.currCollectibles)
	print(global.collectibles)
	queue_free()
