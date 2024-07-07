extends Control

func _ready():
	get_tree().paused = false
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

