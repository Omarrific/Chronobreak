extends AnimatableBody2D


#If true, the spawner launches missiles immediately, otherwise it must be activated
#by the player or some other source 
@export var isOn:bool

#Determines what type of missiles are launched
@export var normalMissiles:bool
@export var rewindMissiles:bool
@export var chronoMissiles: bool 

#Determines length of time between each missile spawn
@export var spawnTime:float

#Determines how long a missile will fly before despawning
@export var lifeTime:float

#Determines the minimum speed of a spawned missile
@export var minMissileSpeed:float

@onready var missile_timer = $missileTimer
@onready var missile_on = $turnOn/missileOn
@onready var silo = $silo


#1
const regularMissileType = preload("res://scenes/levelAssets/hazards/regularMissile.tscn")
#2
const rewindMissileType = preload("res://scenes/levelAssets/hazards/rewind_missile.tscn")
#3
const chronoMissileType = preload("res://scenes/levelAssets/hazards/chrono_missile.tscn")

var missileTypes = []
var pickMissile = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("hi")
	missile_timer.set_wait_time(spawnTime)
	if(normalMissiles):
		print("did")
		missileTypes.append(1)
	if(rewindMissiles):
		missileTypes.append(2)
	if(chronoMissiles):
		missileTypes.append(3)
	if(isOn):
		print("on")
		activate()
		
#Allows the missile launcher to activate
func _on_missile_on_body_entered(body):
	if(!isOn):
		isOn = !isOn
		activate()

#Turns the spawner on
func activate():
	if isOn:
		missile_timer.start()

func changeTimer(value):
	missile_timer.set_wait_time(value)

func changeMinSpeed(value):
	minMissileSpeed = value

func changeLifeTime(value):
	lifeTime = value
	
func _on_missile_timer_timeout():
	spawnMissile()
	missile_timer.start()
#Spawns a missile
func spawnMissile():
	pickMissile = missileTypes.pick_random() 
	var currMissile = 0
	if(pickMissile == 1):
		currMissile = regularMissileType.instantiate()
		currMissile.visible = true
		pass
	elif(pickMissile == 2):
		#spawn a rewind missile
		pass
	else:
		#spawn a chrono missile
		pass
	silo.add_child(currMissile)
	currMissile.launch(lifeTime, minMissileSpeed)
	
