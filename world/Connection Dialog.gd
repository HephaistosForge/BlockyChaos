extends PanelContainer


func _on_join_pressed() -> void:
	self.visible = true
	var tween = create_tween()
	tween.tween_property($"../Menu", "modulate", Color(Color.WHITE, 0), 0.1)
	$"../Menu".visible = false
	tween.tween_property(self, "modulate", Color(Color.WHITE, 1), 0.2)
	


func _on_back_button_pressed() -> void:
	$"../Menu".visible = true
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), 0.1)
	self.visible = false
	tween.tween_property($"../Menu", "modulate", Color(Color.WHITE, 1), 0.2)
