extends Node

#make false when releasing versions
var deleteSave = true

var rewinding = false
var direction = 0
var replay_duration = 4.0

var levels = []
var unlockedLevels = 1
var collectibles = []
var currCollectibles = []

#saving game data

var save_path = "user://variable.save"

func _ready():
	load_data()

func save(): 
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#Do this for all variables I want to store
	file.store_var(unlockedLevels)
	file.store_var(collectibles)

func load_data():
	if FileAccess.file_exists(save_path):
		if(deleteSave):
			pass
		else:
			var file = FileAccess.open(save_path, FileAccess.READ)
			unlockedLevels = file.get_var(unlockedLevels)
			collectibles = file.get_var(collectibles)
	else:
		unlockedLevels = 1
		collectibles = []
