extends Area2D

@export var type: String

@onready var world = get_tree().get_first_node_in_group("world")


func _ready():
	self.visible = world.local_player_type() == type

func _on_body_entered(body):
	if !world.is_game_paused:
		body.die()
