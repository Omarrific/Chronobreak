extends Area2D

@onready var timer = $Timer

var player = 0

func _on_body_entered(body):
	Engine.time_scale = 0.5
	player = body
	player.inputs_enabled = false
	player.velocity.x = 0
	player.velocity.y = 0
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1
	player.respawn()
	
