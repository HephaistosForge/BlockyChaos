extends Sprite2D

#func _process(_delta):
#	self.rotation += 0.02

@onready var tween = create_tween()

func _ready():
	tween.set_loops()
	tween.tween_property(self, "rotation", TAU / 12, .5).from_current() \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
