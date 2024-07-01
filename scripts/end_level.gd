extends Control

func process():
	if(visible):
		#doesn't work but maybe just let player still be able to move
		get_tree().paused = true

func _on_next_level_pressed():
	#TBD
	pass # Replace with function body.


func _on_replay_level_pressed():
	get_tree().reload_current_scene()


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/level_menu.tscn")
