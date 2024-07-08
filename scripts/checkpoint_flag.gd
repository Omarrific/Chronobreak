extends Area2D

var entered = false

func _on_body_entered(body):
	if(!entered):
		body.respawn_position = self.global_position
		entered = true
	global.collectibles.append_array(global.currCollectibles)
	global.currCollectibles = []
	global.save()



