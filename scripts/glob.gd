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

#settings stuff
var volume = 0
var resolutionIndex = 2
var isMuted = false
#saving game data

var save_path = "user://variable.save"

func _ready():
	load_data()

func save(): 
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#Do this for all variables I want to store
	file.store_var(unlockedLevels)
	file.store_var(collectibles)
	
	file.store_var(volume)
	file.store_var(resolutionIndex)

func load_data():
	if FileAccess.file_exists(save_path):
		if(deleteSave):
			pass
		else:
			var file = FileAccess.open(save_path, FileAccess.READ)
			unlockedLevels = file.get_var(unlockedLevels)
			collectibles = file.get_var(collectibles)
			volume =  file.get_var(volume)
			resolutionIndex = file.get_var(resolutionIndex)
			isMuted = file.get_var(isMuted)
	else:
		unlockedLevels = 1
		collectibles = []
		volume = 0
		resolutionIndex = 2
		isMuted = false
