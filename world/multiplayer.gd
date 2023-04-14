extends Node

# MPP - MultiPlayerPeer

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 12077
const ADDRESS = "127.0.0.1"
const MAX_PLAYERS = 2

var server: bool

var connected_peer_ids = []
var player_colors = [Color.RED, Color.BLUE, Color.YELLOW, Color.GREEN]
var local_player_character # the Client

func change_from_menu_to_game():
	var parent = get_parent()
	parent.get_node("Menu").visible = false
	parent.get_node("Waiting").visible = true
	parent.get_node("Floor").visible = true


func on_host() -> void:
	change_from_menu_to_game()
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	
	add_new_player(1)
	get_parent().start_game()
	
	# multiplayer_peer.peer_connected.connect(
	multiplayer.peer_connected.connect(
		func(new_peer_id):
			# await get_tree().create_timer(1).timeout # Godot Engine Bug Fix
			
			# rpc("add_newly_connected_player_character", new_peer_id)
			add_newly_connected_player_character.rpc(new_peer_id)
			
			# rpc_id(new_peer_id, "add_previously_connected_players", connected_peer_ids)
			
			add_previously_connected_players.rpc_id(new_peer_id, connected_peer_ids)
			
			add_new_player(new_peer_id)
	)


func on_join() -> void:
	change_from_menu_to_game()
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer


func add_new_player(peer_id) -> void:
	connected_peer_ids.append(peer_id)
	var player_node = preload("res://entities/player/player.tscn").instantiate()
	player_node.set_multiplayer_authority(peer_id)
	var color = Color.RED if peer_id == 1 else Color.BLUE
	var pos = Vector2.ZERO if peer_id == 1 else Vector2.ONE * get_parent().map_size - Vector2.ONE
	
	self.add_child(player_node)
	player_node.init_as_player(color, pos)
	
	if peer_id == multiplayer.get_unique_id():
		local_player_character = player_node


@rpc
func add_newly_connected_player_character(new_peer_id) -> void:
	add_new_player(new_peer_id)


@rpc
func add_previously_connected_players(peer_ids) -> void:
	for peer_id in peer_ids:
		add_new_player(peer_id)


func _on_exit():
	get_tree().quit()
