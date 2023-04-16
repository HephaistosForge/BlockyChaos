extends PanelContainer


var peer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_dismiss_pressed() -> void:
	self.queue_free()


func _on_confirm_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	get_tree().reload_current_scene()
	self.queue_free()
