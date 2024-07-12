extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

@onready var missile_timer = $missileTimer

@onready var killzone = $killzone

#Determines how fast the missile moves
var missileSpeed:int

#1 = +x, 2= -x, 3 = +y, 4 = -y
var direction:int

#these missiles do not interact with the player when they are rewinding
#aka disable layer 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	set_collision_layer_value(1,false)

func _process(delta):
	if(!global.rewinding):
		set_collision_layer_value(1,false)
		set_collision_mask_value(2,false)
		killzone.set_collision_layer_value(1, false)
		killzone.set_collision_mask_value(2,false)
	else:
		set_collision_layer_value(1,true)
		set_collision_mask_value(2,true)
		killzone.set_collision_layer_value(1, true)
		killzone.set_collision_mask_value(2, true)
	
	move_and_collide(Vector2(velocity.x*delta, velocity.y * delta))

func launch(newLifeTime, speed, dir):
	changeLifeTime(newLifeTime)
	changeSpeed(speed)
	changeDirection(dir)
	self.visible = true
	set_collision_layer_value(1,true)
	missile_timer.start()

func changeSpeed(value):
	missileSpeed = value
	setVelocity()

func changeLifeTime(value):
	missile_timer.set_wait_time(value)

func changeDirection(value):
	direction = value
	setVelocity()

func setVelocity():
	if(direction == 1):
		velocity.x = missileSpeed
		velocity.y = 0
	elif(direction == 2):
		velocity.x = -missileSpeed
		velocity.y = 0
	elif(direction == 3):
		velocity.x = 0
		velocity.y = missileSpeed
	else:
		velocity.x = 0
		velocity.y = -missileSpeed

func _on_missile_timer_timeout():
	queue_free()

func _on_timer_timeout():
	queue_free()
