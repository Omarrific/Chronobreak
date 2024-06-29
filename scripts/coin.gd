extends Area2D



func _on_body_entered(body):
	print("Me coin")
	#deletes the coin from scene
	queue_free()
