extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = not Globals.did_show_intro




func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton or event.is_action_pressed("back_to_menu"):
		visible = false
