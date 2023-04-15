extends Area2D

@export var type: String

# Bug Fix: When Blue Player spawns, it seems that RPC call updates color
# too late (?), there await, to give RPC call some time
var can_detect: bool = false


func _ready():
	await get_tree().create_timer(1).timeout
	can_detect = true


func _on_body_entered(body):
	if body.type == type and can_detect:
		body.win()
