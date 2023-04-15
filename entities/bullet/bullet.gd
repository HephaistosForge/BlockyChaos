extends Area2D

@export var type: String

func _ready():
	var world = get_tree().get_first_node_in_group("world")
	visible = world.local_player_type() == type

func _on_body_entered(body):
	body.die()
