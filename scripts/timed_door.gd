extends AnimatableBody2D

@onready var timer = $Timer

@export var rewindOnly:bool
@export var ignoreRewind:bool
@export var rewindable:bool

var rewind_values = {
	"opened": [], #contains true if closed, false if open 
	"timerLeft": [], #contains how much time is left on timer if open
}

var currIndex = 0
var wasOn = false
var prevRewinding = false

func _ready():
	if rewindOnly:
		timer.set_wait_time(0)
	
func _process(delta):
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
			rewind_values["timerLeft"].append(timer.get_time_left())
			currIndex = rewind_values["opened"].size()

	# Check for state change in rewinding
	if prevRewinding != global.rewinding:
		rewind()
	prevRewinding = global.rewinding

	if not ignoreRewind and not timer.is_stopped() and global.rewinding:
		timer.set_paused(true)
		wasOn = true
	elif not ignoreRewind and wasOn and not global.rewinding:
		timer.set_paused(false)
		wasOn = false

func _on_opening_body_entered(body):
	timer.start()
	set_collision_layer_value(1, false)
	self.visible = false

func _on_timer_timeout():
	set_collision_layer_value(1, true)
	self.visible = true

func handleDoor(value):
	# value is currIndex at this moment
	set_collision_layer_value(1, rewind_values["opened"][value])
	self.visible = rewind_values["opened"][value]
	if rewind_values["timerLeft"][value] <= 0.05:
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
		if timer.get_wait_time() < timer.get_wait_time():
			timer.set_paused(false)
			timer.start()

func compute_rewind(delta):
	if global.direction == -1:
		if currIndex - 1 >= 0:
			currIndex -= 1
			handleDoor(currIndex)
	elif global.direction == 1:
		if currIndex + 1 < rewind_values["opened"].size():
			currIndex += 1
			handleDoor(currIndex)
