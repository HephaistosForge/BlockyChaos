extends CharacterBody2D

@export var color: Color = Color.RED

func _ready():
	$Body/BodySprite.self_modulate = color

func _input(event):
	if get_parent().is_visible() and event is InputEventMouseMotion and is_multiplayer_authority():
		var lefteye = $Body/LeftEye.get_global_position()
		var righteye = $Body/RightEye.get_global_position()
		$Body/LeftEye/LeftEyePupil.set_global_position(lefteye + \
			(event.position - Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2) - lefteye).normalized() * 4)
		$Body/RightEye/RightEyePupil.set_global_position(righteye + \
			(event.position - Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2) - righteye).normalized() * 4)
