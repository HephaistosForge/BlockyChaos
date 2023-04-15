extends Node2D

@export var type: String

func _ready():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "rotation", 500, 2 + randf() * 2).from_current() \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation", 0, randf()).from_current()
	
	# self.visible = type != Globals.local_player_type
