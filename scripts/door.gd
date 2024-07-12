extends AnimatableBody2D

@export var rewindOnly:bool

#this type of door can't really ignore rewind, but for consistency we'll leave this here
@export var ignoreRewind:bool

@export var rewindable:bool

@onready var open = $open

@onready var opening = $open/opening

#deals with rewinding 
var rewind_values = {
	"opened": [], #contains true if closed, false if open 
}

var currIndex = 0;


func _ready():
	if(rewindOnly && !global.rewinding):
		handleButton(false)
	else:
		handleButton(true)		
#to open door
func _on_opening_body_entered(body):
	if(!rewindOnly):
		handleDoor(false)
	else:
		if(body.rewinding):
			handleDoor(false)
			
func _process(delta):	
	if(rewindOnly && !global.rewinding):
		handleButton(false)
	else:
		handleButton(true)		
	if Input.is_action_just_pressed("rewind") && global.rewinding && rewindable:
		rewind()
		
func _physics_process(delta):

	if(rewindable):	
		if(global.rewinding ):
			compute_rewind(delta)
		else:
			#store the variables for rewinding
			if global.replay_duration * Engine.physics_ticks_per_second == rewind_values["opened"].size():
				#matters when I have more things stored
				for key in rewind_values.keys():
					rewind_values[key].pop_front()
					
			rewind_values["opened"].append(get_collision_layer_value(1))
			currIndex = rewind_values["opened"].size()

func handleDoor(value):
	set_collision_layer_value(1, value)
	self.visible = value

func rewind():
	if(global.rewinding && rewindable):
		while(rewind_values["opened"].size() > currIndex+1):
			for key in rewind_values.keys():
				rewind_values[key].pop_back()

func compute_rewind(delta):
	if(global.direction == -1):
		if(currIndex-1 >= 0):
			currIndex = currIndex-1 #-- doesn't work?
			handleDoor(rewind_values["opened"][currIndex])
	elif(global.direction == 1):
		if(currIndex+1 < rewind_values["opened"].size()):
			currIndex = currIndex+1 #++ doesn't work?
			handleDoor(rewind_values["opened"][currIndex])

func handleButton(value):
	open.visible = value
	opening.set_collision_layer_value(1,false)
