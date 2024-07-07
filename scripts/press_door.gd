extends AnimatableBody2D

@export var rewindOnly:bool
@onready var buttonArea = $button/Area2D
@onready var button = $button


var isInside = false
var isOn = true

func _ready():
	if(rewindOnly):
		handle_button(false)

func _process(delta):
	if(rewindOnly):
		if(global.rewinding):
			handle_button(true)
		else:
			handle_button(false)
			
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
		






