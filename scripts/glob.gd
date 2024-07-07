extends Node

var levels = []
var unlockedLevels = 1
var collectibles = []

#saving game data

var save_path = "user://variable.save"

func _ready():
	load_data()

func save(): 
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#Do this for all variables I want to store
	file.store_var(unlockedLevels)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		unlockedLevels = file.get_var(unlockedLevels)
	else:
		unlockedLevels = 1
