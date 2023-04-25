extends Label



func _ready():
	visible = Globals.load_difficulty_completed(get_parent().get_node("Number").text) 
