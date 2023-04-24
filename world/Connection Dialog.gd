extends PanelContainer

signal connect_to(address, port)
@export var address_node: Node
@export var port_node: Node

func _ready():
	self.visible = false


func _on_join_pressed() -> void:
	self.visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 1), 0.2)
	


func _on_back_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), 0.1)
	self.visible = false


func _on_connect_pressed():
	emit_signal("connect_to", address_node.text, int(port_node.text))
