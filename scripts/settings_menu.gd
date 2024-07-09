extends Control

@onready var volume = $MarginContainer/VBoxContainer/Volume
@onready var mute_button = $MarginContainer/VBoxContainer/MuteButton
@onready var resolutions = $MarginContainer/VBoxContainer/Resolutions

func _ready():
	AudioServer.set_bus_volume_db(0,global.volume)
	toggleMute(global.isMuted)
	changeRes(global.resolutionIndex)
	volume.value = global.volume
	resolutions.select(global.resolutionIndex)
	
	

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
	global.volume = AudioServer.get_bus_volume_db(0)
	global.save()


func _on_mute_button_toggled(toggled_on):
	toggleMute(toggled_on)
	global.save()
	
func toggleMute(value):
	mute_button.button_pressed = value
	AudioServer.set_bus_mute(0,value)
	global.isMuted = value

func _on_resolutions_item_selected(index):
	changeRes(index)
	global.resolutionIndex = index
	

func changeRes(index):
	match index:
		0: 
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))

func _on_back_pressed():
	self.visible = false
	self.set_process(false)
	global.save()

