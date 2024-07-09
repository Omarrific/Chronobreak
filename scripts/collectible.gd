extends Area2D

@export var collectibleNum:int
@export var rewindOnly: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	if(global.collectibles.has(collectibleNum)):
		queue_free()
	if(rewindOnly):
		handle_collision(false)

func _process(delta):
	if(rewindOnly):
		if(global.rewinding && !global.currCollectibles.has(collectibleNum) && !global.collectibles.has(collectibleNum)):
			handle_collision(true)
		else:
			handle_collision(false)
	else:
		if(!global.collectibles.has(collectibleNum) && !global.currCollectibles.has(collectibleNum)):
			handle_collision(true)

func handle_collision(value):
	self.visible = value
	set_collision_layer_value(1,value)

func _on_body_entered(body):
	if(!global.currCollectibles.has(collectibleNum) && !global.collectibles.has(collectibleNum)):
		global.currCollectibles.append(collectibleNum)
		handle_collision(false)
