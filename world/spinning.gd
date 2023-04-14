extends TextureRect

@onready var tween = create_tween()

var rotate_by = deg_to_rad(360 / 16)

func _ready():
	tween_rotate()
	#tween.set_loops(1000)
	#tween.tween_property(self, "rotation", rotation + rotate_by, .3)


func tween_rotate():
	#await tween.finished
	tween = create_tween()
	tween.tween_property(self, "rotation", rotation + rotate_by, .1)
	tween.tween_callback(self.tween_rotate)
