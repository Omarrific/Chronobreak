extends Node2D

var currOpen = 1

@onready var door1 = $door1/door
@onready var door2 = $door2/door
@onready var door3 = $door3/door
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	openOne()

func openOne():
	currOpen = 1
	door1.visible = false
	door2.visible = true
	door3.visible = true
	door1.set_collision_layer_value(1, false)
	door2.set_collision_layer_value(1, true)
	door3.set_collision_layer_value(1, true)
	timer.start()
	
func openTwo():
	currOpen = 2
	door1.visible = true
	door2.visible = false
	door3.visible = true
	door1.set_collision_layer_value(1, true)
	door2.set_collision_layer_value(1, false)
	door3.set_collision_layer_value(1, true)
	timer.start()
	
func openThree():
	currOpen = 3
	door1.visible = true
	door2.visible = true
	door3.visible = false
	door1.set_collision_layer_value(1, true)
	door2.set_collision_layer_value(1, true)
	door3.set_collision_layer_value(1, false)
	timer.start()

func _on_timer_timeout():
	if(currOpen == 1):
		openTwo()
	elif(currOpen == 2):
		openThree()
	else:
		openOne()
	
