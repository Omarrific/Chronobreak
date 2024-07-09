extends Control


@onready var settings_menu = $settings_menu

@onready var grid_container = $GridContainer
@onready var color_rect = $ColorRect



func _ready():
	self.visible = false
	self.set_process(false)
	
func _process(delta):
	if _is_paused:
		self.visible = true
		if(settings_menu.visible):
			enablePause(false)
		else:
			enablePause(true)
	else:
		self.visible = false
		self.set_process(false)
		

var _is_paused = false: 
	set = set_paused

func set_paused(value):
	_is_paused = value
	get_tree().paused = _is_paused
	if not settings_menu.visible:
		self.visible = _is_paused
		self.set_process(_is_paused)


func _unhandled_input(event):
	if event.is_action_pressed("pause") && !settings_menu.visible:
		_is_paused = !_is_paused


func _on_resume_pressed():
	_is_paused = false

func _on_settings_pressed():
	settings_menu.visible = true
	settings_menu.set_process(true)

func _on_settings_back_pressed():
	enablePause(true)
	
func _on_restart_level_pressed():
	_is_paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/level/level_menu.tscn")

func enablePause(value):
	#if true, turn pause on and settings off, else otherway
	grid_container.visible = value
	grid_container.set_process(value)
	settings_menu.visible = !value
	settings_menu.set_process(!value)
