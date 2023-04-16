extends PanelContainer

@onready var main_menu = get_parent().get_node("Menu")

func _on_back_button_pressed() -> void:
	main_menu.visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), 0.1)
	self.visible = false
	tween.tween_property(main_menu, "modulate", Color(Color.WHITE, 1), 0.2)


func _on_how_to_play_pressed() -> void:
	self.visible = true
	var tween = create_tween()
	tween.tween_property(main_menu, "modulate", Color(Color.WHITE, 0), 0.1)
	main_menu.visible = false
	tween.tween_property(self, "modulate", Color(Color.WHITE, 1), 0.2)
