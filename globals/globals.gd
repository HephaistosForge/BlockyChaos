extends Node2D

const GAME_OVER_TEXT: String = "Game Over!"
const WINNING_TEXT: String = "You both won!"

var big_floating_messager_container: VBoxContainer

var did_show_intro = false

var config = ConfigFile.new()

func _ready():
	var err = config.load("user://persistent.cfg")
	if err != OK:
		pass


func display_big_floating_message(text: String) -> void:
	big_floating_messager_container.display_message(text)
	big_floating_messager_container.visible = true


func hide_big_floating_message() -> void:
	big_floating_messager_container.visible = false

func look_with_pupil_at_mouse(eye):
	var pupil = eye.get_node(eye.name + "Pupil")
	var mouse_pos = get_global_mouse_position()
	var eye_pos = eye.get_global_position()
	var squint_factor = 1
	
	var direction = (mouse_pos - eye_pos) / squint_factor
	if direction.length() > 70:
		direction = direction.normalized() * 70
	pupil.global_position = eye.global_position + direction * pupil.global_scale


func save_difficulty_completed(difficulty):
	assert(difficulty is String)
	config.set_value("difficulty_completed", difficulty, true)
	config.save("user://persistent.cfg")

func load_difficulty_completed(difficulty):
	assert(difficulty is String)
	return config.get_value("difficulty_completed", difficulty, false)
	
