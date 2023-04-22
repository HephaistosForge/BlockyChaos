extends Node2D

@export var color: Color = Color.RED

#var tween

func _ready():
	$Body/BodySprite.self_modulate = color


func _process(_delta):
	if get_parent().is_visible() and visible:
		Globals.look_with_pupil_at_mouse($Body/LeftEye)
		Globals.look_with_pupil_at_mouse($Body/RightEye)
