extends Area2D

signal player_win

var entered = false


func _on_body_entered(body):
	if(!entered):
		emit_signal("player_win")
		entered = true
	
