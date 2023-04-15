extends VBoxContainer


func _ready():
	Globals.big_floating_messager_container = self


func display_message(text: String) -> void:
	self.visible = true
	$BigFloatingMessage.text = text
