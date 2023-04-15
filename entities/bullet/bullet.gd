extends Area2D

@export var type: String



func _on_body_entered(body):
	print(body)
	body.die()
