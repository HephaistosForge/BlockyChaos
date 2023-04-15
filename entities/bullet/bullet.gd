extends Area2D

@export var type: String



func _on_body_entered(body):
	if body.type == type:
		body.die()
