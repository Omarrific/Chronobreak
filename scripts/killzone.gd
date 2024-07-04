extends Area2D

@onready var timer = $Timer

var player = 0

signal player_killed

func _on_body_entered(body):
	Engine.time_scale = 0.5
	player = body
	body.inputs_enabled = false
	timer.start()

func _on_timer_timeout():
	#Need to fix if I add checkpoints
	Engine.time_scale = 1
	
	player.respawn()
	
	
