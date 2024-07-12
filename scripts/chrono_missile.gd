extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

@onready var missile_timer = $missileTimer

@onready var killzone = $killzone

#Determines how fast the missile moves
var missileSpeed:int

#1 = +x, 2= -x, 3 = +y, 4 = -y
var direction:int

var rewind_values = {
	"position": [],
	"speed": [],
	"direction": [],
	"timerLeft": [],
}

var currIndex = 0
var prevRewinding = false
var wasTimerRunning = false
#these missiles do not interact with the player when they are rewinding
#aka disable layer 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	set_collision_layer_value(1,false)
	self.set_rotation_degrees(90)

func _process(delta):
	if(global.rewinding):
		velocity = Vector2.ZERO
		missile_timer.set_paused(true)
		compute_rewind(delta)
	else:
		missile_timer.set_paused(false)
		setVelocity()
		# Store the variables for rewinding
		if global.replay_duration * Engine.physics_ticks_per_second == rewind_values["position"].size():
			# Limit the stored history to the duration of the replay
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
		rewind_values["position"].append(global_position)
		rewind_values["speed"].append(missileSpeed)
		rewind_values["direction"].append(direction)
		rewind_values["timerLeft"].append(missile_timer.get_time_left())
		currIndex = rewind_values["position"].size()
	
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
	
func compute_rewind(delta):
	if global.direction == -1:
		if currIndex - 1 >= 0:
			currIndex -= 1
			handleMissile(currIndex)
	elif global.direction == 1:
		if currIndex + 1 < rewind_values["position"].size():
			currIndex += 1
			handleMissile(currIndex)

func handleMissile(value):
	global_position = rewind_values["position"][currIndex]
	missileSpeed = rewind_values["speed"][currIndex]
	direction = rewind_values["direction"][currIndex]
	
	if rewind_values["timerLeft"][value] <= 0.05:
		queue_free()
	else:
		missile_timer.set_wait_time(rewind_values["timerLeft"][value])
		missile_timer.start()


func _on_killzone_body_entered(body):
	missile_timer.set_paused(true)
