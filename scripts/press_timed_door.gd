extends AnimatableBody2D

var isInside = false
var isOn = true



#When rewindOnly, you can only press the button while rewinding
@export var rewindOnly:bool

#When ignoreRewind, the timer continues ticking while rewinding, otherwise
#the timer is paused while rewinding
@export var ignoreRewind:bool

#When rewindable, holds the state of the door, as well as the time remaining if open, 
#always initial time if closed
@export var rewindable:bool

#can't be both ignore rewind and rewindable for this door type

@onready var timer = $Timer
#initial value

var waitTime = 0

var wasOn = false
var rewind_values = {
	"opened": [], #contains true if closed, false if open
	"timerLeft": [], #contains how much time is left on timer if open, init if closed
}
var currIndex = 0
var prevRewinding = false

func _ready():
	waitTime = timer.get_wait_time()

func _on_opening_body_entered(body):
	isInside = true
	
func _on_opening_body_exited(body):
	isInside = false
	
func _unhandled_input(event):
	if(rewindOnly):
		if(event.is_action("interact") && isInside && isOn && global.rewinding):
			set_collision_layer_value(1, false)
			self.visible = false
			isOn = false
			timer.start()
	else:
		if(event.is_action("interact") && isInside && isOn):
			set_collision_layer_value(1, false)
			self.visible = false
			isOn = false
			timer.start()

func _process(delta):
	if(rewindable):
		if Input.is_action_just_pressed("rewind") and global.rewinding:
			rewind()
	else:
		if(global.rewinding):
			#If I do not ignore rewind and my timer is going, I pause the timer
			if(!ignoreRewind && !timer.is_stopped()):
				wasOn = true
				timer.set_paused(true)
		else:
			if(!ignoreRewind && wasOn):
				wasOn = false
				timer.set_paused(false)
	
	# Check for state change in rewinding
	if rewindable and prevRewinding != global.rewinding:
		rewind()
	prevRewinding = global.rewinding
				
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
			rewind_values["timerLeft"].append(timer.get_time_left())
			currIndex = rewind_values["opened"].size()
				
func handleDoor(value):
	# value is currIndex at this moment
	set_collision_layer_value(1, rewind_values["opened"][value])
	self.visible = rewind_values["opened"][value]
	isOn = rewind_values["opened"][value]
	if rewind_values["timerLeft"][value] <= 0.05:
		timer.set_wait_time(waitTime)
		timer.stop()
	else:
		timer.set_wait_time(rewind_values["timerLeft"][value])
		timer.start()
	
func rewind():
	if global.rewinding and rewindable:
		while rewind_values["opened"].size() > currIndex + 1:
			for key in rewind_values.keys():
				rewind_values[key].pop_back()
	elif not global.rewinding and rewindable:
		if timer.get_wait_time() < waitTime:
			timer.start()
			timer.set_paused(false)
	
func compute_rewind(delta):
	if(global.direction == -1):
		if(currIndex-1 >= 0):
			currIndex = currIndex-1 #-- doesn't work?
			handleDoor(currIndex)
	elif(global.direction == 1):
		if(currIndex+1 < rewind_values["opened"].size()):
			currIndex = currIndex+1 #++ doesn't work?
			handleDoor(currIndex)


func _on_timer_timeout():
	set_collision_layer_value(1, true)
	self.visible = true
	isOn = true 
	timer.set_wait_time(waitTime)
	




