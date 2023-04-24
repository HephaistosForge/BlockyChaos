extends Control

#var world_scene = preload("res://world/world.tscn")
var switching = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = not Globals.did_show_intro

func switch_scene():
	if not switching:
		switching = true
		get_tree().change_scene_to_file("res://world/world.tscn")

func _input(event):
	if not (event is InputEventMouseMotion):
		switch_scene()
