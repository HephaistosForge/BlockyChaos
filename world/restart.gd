extends Button


func _on_button_down():
	rpc("restart_peer")


@rpc("any_peer", "call_local", "reliable")
func restart_peer():
	for player in get_tree().get_nodes_in_group("players"):
		player.restart()
