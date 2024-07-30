extends Node2D

@onready var missile_spawner = $missile/missile_spawner
@onready var missile_spawner2 = $missile/missile_spawner2
@onready var missile_spawner3 = $missile/missile_spawner3
@onready var missile_spawner4 = $missile/missile_spawner4
@onready var missile_spawner5 = $missile/missile_spawner5

# Called when the node enters the scene tree for the first time.
func _ready():
	handleMissile(false)
	

func handleMissile(value):
	if(value):
		missile_spawner.visible = true;
		missile_spawner2.visible = true;
		missile_spawner3.visible = true;
		missile_spawner4.visible = true;
		missile_spawner5.visible = true;
		missile_spawner.activate();
		missile_spawner2.activate();
		missile_spawner3.activate();
		missile_spawner4.activate();
		missile_spawner5.activate();
	else:	
		missile_spawner.visible = false;
		missile_spawner2.visible = false;
		missile_spawner3.visible = false;
		missile_spawner4.visible = false;
		missile_spawner5.visible = false;
		missile_spawner.deactivate();
		missile_spawner2.deactivate();
		missile_spawner3.deactivate();
		missile_spawner4.deactivate();
		missile_spawner5.deactivate();
