extends Node

const GAME_OVER_TEXT: String = "Game Over!"
const WINNING_TEXT: String = "You both won!"

var big_floating_messager_container: VBoxContainer

var did_show_intro = false


func display_big_floating_message(text: String) -> void:
	big_floating_messager_container.display_message(text)
	big_floating_messager_container.visible = true


func hide_big_floating_message() -> void:
	big_floating_messager_container.visible = false
