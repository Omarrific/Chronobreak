extends Control

func _on_next_level_pressed():
	Engine.time_scale = 1
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int()+1
	var next_level_path = "res://scenes/levels/levels/level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	
func _on_replay_level_pressed():
	Engine.time_scale = 1
	get_tree().reload_current_scene()


func _on_menu_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/menus/level/level_menu.tscn")
