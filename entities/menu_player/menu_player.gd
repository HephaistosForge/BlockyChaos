extends Node2D

@export var color: Color = Color.RED

#var tween

func _ready():
	$Body/BodySprite.self_modulate = color
	
func look_with_pupil_at_mouse(eye):
	var pupil = eye.get_node(eye.name + "Pupil")
	var mouse_pos = get_global_mouse_position()
	var eye_pos = eye.get_global_position()
	var squint_factor = 5
	
	var direction = (mouse_pos - eye_pos) / squint_factor
	if direction.length() > 7:
		direction = direction.normalized() * 7
	pupil.global_position = eye.global_position + direction # / eye.scale / scale

func _process(_delta):
	if get_parent().is_visible() and visible:
		look_with_pupil_at_mouse($Body/LeftEye)
		look_with_pupil_at_mouse($Body/RightEye)
