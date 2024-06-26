extends CharacterBody2D

#Basic Control Variables
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var direction = 1 #Initial value, can change later

#Rewind Mechanic Variables
var replay_duration = 4.0
var rewinding = false
#Will hold things like rotation and velocity later
var rewind_values = {
	"position": [],
}
var currIndex = 0;



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _physics_process(delta):
		
	#We can use direction in both rewind and in not rewind
	direction = Input.get_axis("move_left", "move_right")
		
	#If I'm rewinding, do rewind stuff. Otherwise, I shouldn't be able to move
	#or anything like that. When I add in the velocity, position, and animation
	#being saved change the "= 0" and "=1" stuff 
	if rewinding:
		velocity.x = 0
		velocity.y = 0
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

		if(direction > 0):
			animated_sprite.flip_h = false
		elif(direction < 0):
			animated_sprite.flip_h = true
			
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
		
		currIndex = rewind_values["position"].size()
			
	move_and_slide()

#useless for now
func rewind(): #TBD 
	if(rewinding):
		#Deletes everything in the position array that comes AFTER the index
		#you stop at
		while(rewind_values["position"].size() > currIndex+1):
			rewind_values["position"].pop_back()
	else:
		#able to move through objects while in rewind mode, but make it so 
		# not be able to deactivate rewind until not colliding with anything
		collision_shape.set_deferred("disabled", true)
	rewinding = !rewinding
	
	

	
	
func compute_rewind(delta,direction):
	if(direction == -1):
		if(currIndex-1 >= 0):
			currIndex = currIndex-1 #-- doesn't work?
			global_position = rewind_values["position"][currIndex]
	elif(direction == 1):
		if(currIndex+1 < rewind_values["position"].size()):
			currIndex = currIndex+1 #++ doesn't work?
			global_position = rewind_values["position"][currIndex]
			
func _process(delta):
	if Input.is_action_just_pressed("rewind"):
		rewind()
	
	
