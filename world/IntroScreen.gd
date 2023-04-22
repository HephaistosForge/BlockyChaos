extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = not Globals.did_show_intro


