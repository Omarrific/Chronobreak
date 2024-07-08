extends CharacterBody2D

class_name Player

#Basic Control Variables
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var direction = 0 #Initial value, can change later

#Rewind Mechanic Variables
var replay_duration = 4.0
var rewinding = false
#Will hold things like rotation and velocity later
var rewind_values = {
	"position": [],
	"xVelocity": [],
	"yVelocity": [],
	"direction": [], # -1, 0, 1
}
var currIndex = 0;

var currX = 0; #xVel
var currY = 0; #yVel

#Respawn Variables
var respawn_position = global_position
var inputs_enabled = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _physics_process(delta):
	if(inputs_enabled):
		#We can use direction in both rewind and in not rewind
		direction = Input.get_axis("move_left", "move_right")
			
		#If I'm rewinding, do rewind stuff. Otherwise, I shouldn't be able to move
		#or anything like that. When I add in the velocity, position, and animation
		#being saved change the "= 0" and "=1" stuff 
		if rewinding:
			animated_sprite.speed_scale = 0
			compute_rewind(delta,direction)
		else:
			animated_sprite.speed_scale = 1
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta

			# Handle jump.
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			#Gets input direction: -1, 0, 1
			direction = Input.get_axis("move_left", "move_right")
			
			directionCheck(direction)
				
			#Play animations
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")

			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			
			#store the variables for rewinding
			if replay_duration * Engine.physics_ticks_per_second == rewind_values["position"].size():
				#matters when I have more things stored
				for key in rewind_values.keys():
					rewind_values[key].pop_front()
					
			rewind_values["position"].append(global_position)
			rewind_values["direction"].append(direction)
			currIndex = rewind_values["position"].size()
			
	move_and_slide()

func rewind(): 
	if(rewinding):
		#Deletes everything in the position array that comes AFTER the index
		#you stop at
		while(rewind_values["position"].size() > currIndex+1):
			for key in rewind_values.keys():
				rewind_values[key].pop_back()
			
		set_collision_mask_value(1,true)
		Engine.time_scale = 1
	else:
		#able to move through objects while in rewind mode, but make it so 
		# not be able to deactivate rewind until not colliding with anything
		set_collision_mask_value(1, false)
		Engine.time_scale = 0
	rewinding = !rewinding
	global.rewinding = !global.rewinding

	
func compute_rewind(delta,direction):
	if(direction == -1):
		if(currIndex-1 >= 0):
			currIndex = currIndex-1 #-- doesn't work?
			global_position = rewind_values["position"][currIndex]
			direction = rewind_values["direction"][currIndex]
			directionCheck(direction)
			
	elif(direction == 1):
		if(currIndex+1 < rewind_values["position"].size()):
			currIndex = currIndex+1 #++ doesn't work?
			global_position = rewind_values["position"][currIndex]
			direction = rewind_values["direction"][currIndex]
			directionCheck(direction)
			
func _process(delta):
	if Input.is_action_just_pressed("rewind") && inputs_enabled:
		if(!rewinding): #maybe helps with rewind velocity
			velocity.x = 0
			velocity.y = 0
		rewind()

func directionCheck(direction):
	if(direction > 0):
		animated_sprite.flip_h = false
	elif(direction < 0):
		animated_sprite.flip_h = true
	
func respawn():
	global_position = respawn_position
	inputs_enabled = true
	resetRewind()
	rewinding = false
	set_collision_mask_value(1,true)
	global.currCollectibles = []
	

func resetRewind():
		rewind_values = {
		"position": [],
		"xVelocity": [],
		"yVelocity": [],
		"direction": [], # -1, 0, 1
	}
