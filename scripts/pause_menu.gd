extends Control

var _is_paused = false: 
	set = set_paused

func set_paused(value):
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused

func _on_resume_pressed():
	_is_paused = false

func _on_settings_pressed():
	pass # Replace with function body.
	
func _on_restart_level_pressed():
	_is_paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/level/level_menu.tscn")
