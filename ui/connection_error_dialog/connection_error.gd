extends PanelContainer


func set_error_message(_text):
	$MarginContainer/VBoxContainer/HBoxContainer/RichTextLabel.text = _text


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
	self.queue_free()
	get_tree().paused = false
	
