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
@export var missileSpeed:float

#Determines the direction missiles will shoot
#1 = +x, 2 = -x, 3 = +y, 4 = -y
@export var missileDirection:int

@onready var missile_timer = $missileTimer
@onready var missile_on = $turnOn/missileOn
@onready var silo = $silo


#1 Can only hit player while not rewinding
const regularMissileType = preload("res://scenes/levelAssets/hazards/regularMissile.tscn")
#2 Can only hit player while rewinding
const rewindMissileType = preload("res://scenes/levelAssets/hazards/rewind_missile.tscn")
#3 Can ALWAYS hit player, but the player can rewind it's position alongside themself
const chronoMissileType = preload("res://scenes/levelAssets/hazards/chrono_missile.tscn")

var missileTypes = []
var pickMissile = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	missile_timer.set_wait_time(spawnTime)
	if(normalMissiles):
		missileTypes.append(1)
	if(rewindMissiles):
		missileTypes.append(2)
	if(chronoMissiles):
		missileTypes.append(3)
	if(isOn):
		activate()

func _process(delta):
	if(global.rewinding || !isOn):
		missile_timer.set_paused(true)
	else:
		missile_timer.set_paused(false)

#Allows the missile launcher to activate
func _on_missile_on_body_entered(body):
	if(!isOn):
		isOn = !isOn
		activate()

#Turns the spawner on
func activate():
	if isOn:
		spawnMissile()
		missile_timer.start()

func deactivate():
	isOn = false

func changeTimer(value):
	missile_timer.set_wait_time(value)

func changeMinSpeed(value):
	missileSpeed = value

func changeLifeTime(value):
	lifeTime = value
	
func _on_missile_timer_timeout():
	spawnMissile()
	missile_timer.start()
#Spawns a missile
func spawnMissile():
	pickMissile = missileTypes.pick_random() 
	var currMissile =  regularMissileType.instantiate()
	if(pickMissile == 2):
		currMissile = rewindMissileType.instantiate()
	elif(pickMissile == 3):
		currMissile = chronoMissileType.instantiate()
	silo.add_child(currMissile)
	currMissile.launch(lifeTime, missileSpeed, missileDirection)
	
	
