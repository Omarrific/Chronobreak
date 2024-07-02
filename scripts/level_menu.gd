extends Control

const LEVEL_BTN = preload("res://scenes/menus/level/level_button.tscn")

@export_dir var dir_path

@onready var grid  = $MarginContainer/VBoxContainer/GridContainer

func _ready():
	get_levels(dir_path)

	
func get_levels(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while(file_name != ""):
			create_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name) 
			#Might need more %S
			file_name = dir.get_next()
		dir.list_dir_end()
		
		for i in range(grid.get_child_count()):
			global.levels.append(i+1)
		for level in grid.get_children():
			var level_text = int(level.text.trim_prefix('level '))
			if level_text in range(global.unlockedLevels+1):
				level.disabled = false
			else:
				level.disabled = true
				
				
	else:
		print('No level path found')
	
func create_level_btn(level_path, level_name):
	var btn = LEVEL_BTN.instantiate()
	btn.text = level_name.trim_suffix('.tscn').replace('_', " ")
	btn.level_path = level_path
	grid.add_child(btn)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
