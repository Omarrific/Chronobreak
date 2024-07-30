class_name MainMenu

extends Control

@export var main_game_packed_scene: PackedScene = null

@onready var settings_menu = $settings_menu

@onready var main = $main

@onready var settings_button = $"MarginContainer/VBoxContainer/Settings Button"

func _ready():
	get_tree().paused = false
	settings_menu.set_process(false)

func _on_start_button_button_down():
	get_tree().change_scene_to_packed(main_game_packed_scene)

func _on_settings_button_button_down():
	main.visible = false
	main.set_process(false)
	settings_menu.visible = true
	settings_menu.set_process(true)
	
func _process(delta):
	if(!settings_menu.visible):
		main.visible = true
		main.set_process(true)

func _on_quit_button_button_down():
	get_tree().quit()

