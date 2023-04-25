extends Label

@export var recommended_num = 3

func _ready():
	visible = str(get_parent().get_parent().get_node("Number").text) == str(recommended_num)
