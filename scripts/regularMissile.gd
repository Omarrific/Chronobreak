class_name Missile

extends AnimatableBody2D

@onready var timer = $Timer
@onready var missile = $missile


#Determines how fast the missile moves
var missileSpeed:int

#Determines how long the missile lasts before despawning
var lifeTime:float

#these missiles do not interact with the player when they are rewinding
#aka disable layer 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	missile.set_collision_layer_value(1,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func launch(lifeTime, speed):
	changeLifeTime(lifeTime)
	changeSpeed(speed)
	self.visible = true
	missile.set_collision_layer_value(1,true)


func changeSpeed(value):
	missileSpeed = value

func changeLifeTime(value):
	timer.set_wait_time(lifeTime)


#Despawns the missile after timer timeout
func _on_timer_timeout():
	queue_free()
