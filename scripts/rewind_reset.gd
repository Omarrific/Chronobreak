extends Area2D




func _on_body_entered(body):
	#Deletes the rewind values after touching the box
	body.rewind_values = {
	"position": [],
	"xVelocity": [],
	"yVelocity": [],
	"direction": [], # -1, 0, 1
}
