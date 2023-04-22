extends PanelContainer

@onready var main_menu = get_parent().get_node("Menu")

class Difficulty:
	func _init(traps, bullets, bullets_can_spawn_on_player_row=false):
		self.traps = traps
		self.bullets = bullets
		self.bullets_can_spawn_on_player_row = bullets_can_spawn_on_player_row
	
	var traps: int
	var bullets: int
	var bullets_can_spawn_on_player_row: int


var difficulty_button_scene = preload("res://ui/difficulty_dialog/difficulty_button.tscn")
@export var difficulty_hbox_container: Node

var difficulties = [
	Difficulty.new(6, 0),
	Difficulty.new(8, 1),
	Difficulty.new(10, 2),
	Difficulty.new(12, 3, true),
	Difficulty.new(14, 4, true),
]

func _ready():
	if difficulty_hbox_container != null:
		for difficulty in difficulties:
			var difficulty_button = difficulty_button_scene.instantiate()
			difficulty_button.set_difficulty(difficulty)
			difficulty_hbox_container.add_child(difficulty_button)

func _on_back_button_pressed() -> void:
	main_menu.visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), 0.1)
	self.visible = false
	tween.tween_property(main_menu, "modulate", Color(Color.WHITE, 1), 0.2)


func _on_settings_pressed() -> void:
	self.visible = true
	var tween = create_tween()
	tween.tween_property(main_menu, "modulate", Color(Color.WHITE, 0), 0.1)
	main_menu.visible = false
	tween.tween_property(self, "modulate", Color(Color.WHITE, 1), 0.2)
	

func set_audio_bus_db(audio_bus_name, value):
	var db = -(100 - value) / 3
	print(audio_bus_name, db)
	var audio_bus_index = AudioServer.get_bus_index(audio_bus_name)
	AudioServer.set_bus_volume_db(audio_bus_index, db)
	AudioServer.set_bus_mute(audio_bus_index, value == 0)


func _on_slider_sounds_value_changed(value):
	set_audio_bus_db("Sounds", value)


func _on_slider_music_value_changed(value):
	set_audio_bus_db("Music", value)
