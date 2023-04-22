extends PanelContainer

@export var trap_label: Node
@export var bullet_label: Node

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, .1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, .1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func set_difficulty(difficulty):
	trap_label.text = str(difficulty.traps)
	bullet_label.text = str(difficulty.traps)
