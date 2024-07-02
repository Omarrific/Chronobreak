extends Area2D

signal player_win

var entered = false


func _on_body_entered(body):
	if(!entered):
		emit_signal("player_win")
		entered = true
		var currScene = get_tree().current_scene.levelNumber
		global.unlockedLevels = max(global.unlockedLevels, currScene+1)
		global.save()
	
