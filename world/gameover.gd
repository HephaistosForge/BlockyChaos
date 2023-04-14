extends Label

@onready var tween = create_tween()

func _ready():
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, .5) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE, .5) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
