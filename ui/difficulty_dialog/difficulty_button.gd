extends PanelContainer

@export var trap_label: Node
@export var trap_image: Node
@export var bullet_label: Node
@export var bullet_image: Node

@onready var initial_scale = scale
@onready var target_scale = initial_scale * 1.2

var difficulty

signal difficulty_clicked(difficulty)

func _on_mouse_entered():
	if scale != target_scale:
		var tween = create_tween()
		tween.tween_property(self, "scale", target_scale, .1) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(self, "modulate", Color(2, 2, 2, 1), .1) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func _on_mouse_exited():
	if scale != initial_scale:
		var tween = create_tween()
		tween.tween_property(self, "scale", initial_scale, .1) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(self, "modulate", Color.WHITE, .1) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func set_difficulty(difficulty):
	self.difficulty = difficulty
	trap_label.text = str(difficulty.traps)
	bullet_label.text = str(difficulty.bullets)
	
	var trap_scale = sqrt(difficulty.traps / 10)
	var bullet_scale = sqrt(difficulty.bullets / 2)
	
	#trap_label.set("theme_override_font_sizes/font_size", 40 * trap_scale)
	#bullet_label.set("theme_override_font_sizes/font_size", 40 * bullet_scale)

	#trap_image.set("custom_minimum_size", Vector2.ONE * 32 * trap_scale)
	#bullet_image.set("custom_minimum_size", Vector2.ONE * 32 * bullet_scale)


func _on_button_pressed():
	emit_signal("difficulty_clicked", difficulty)


func _on_gui_input(event):
	if event is InputEventMouseButton:
		emit_signal("difficulty_clicked", difficulty)
