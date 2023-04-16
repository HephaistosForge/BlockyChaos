extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.did_show_intro:
		self.visible = false


