extends AnimatableBody2D

@export var rewindOnly:bool
@export var ignoreRewind:bool
@export var rewindable:bool
@onready var buttonArea = $button/Area2D
@onready var button = $button


var isInside = false
var isOn = true

var rewind_values = {
	"opened": [], #contains true if closed, false if open 
}

var currIndex = 0
var prevRewinding = false


func _ready():
	if(rewindOnly):
		handle_button(false)

func _process(delta):
	if rewindOnly:
		if global.rewinding:
			handle_button(true)
		else:
			handle_button(false)
	# Check for state change in rewinding
	if rewindable && prevRewinding != global.rewinding:
		rewind()
	prevRewinding = global.rewinding

func _physics_process(delta):
	if rewindable:
		if global.rewinding:
			compute_rewind(delta)
		else:
			# Store the variables for rewinding
			if global.replay_duration * Engine.physics_ticks_per_second == rewind_values["opened"].size():
				# Limit the stored history to the duration of the replay
				for key in rewind_values.keys():
					rewind_values[key].pop_front()
			rewind_values["opened"].append(get_collision_layer_value(1))
			currIndex = rewind_values["opened"].size()
			
func rewind():
	if global.rewinding and rewindable:
		while rewind_values["opened"].size() > currIndex + 1:
			for key in rewind_values.keys():
				rewind_values[key].pop_back()
				
func compute_rewind(delta):
	if global.direction == -1:
		if currIndex - 1 >= 0:
			currIndex -= 1
			handleDoor(currIndex)
	elif global.direction == 1:
		if currIndex + 1 < rewind_values["opened"].size():
			currIndex += 1
			handleDoor(currIndex)
	
func handle_button(value):
	button.visible = value
	buttonArea.set_collision_layer_value(1,value)
		
func _on_area_2d_body_entered(body):
	isInside = true

func _on_area_2d_body_exited(body):
	isInside = false

func _unhandled_input(event):
	if(rewindOnly):
		if(event.is_action("interact") && isInside && isOn && global.rewinding):
			set_collision_layer_value(1, false)
			self.visible = false
			isOn = false
	else:
		if(event.is_action("interact") && isInside && isOn):
			set_collision_layer_value(1, false)
			self.visible = false
			isOn = false
		
func handleDoor(value):
	# value is currIndex at this moment
	set_collision_layer_value(1, rewind_values["opened"][value])
	self.visible = rewind_values["opened"][value]
	isOn = rewind_values["opened"][value]






