extends Node2D

@export var is_game_paused: bool = false
@export var traps = {}

var map_size = Vector2(10, 10)
var box_size = 100
var line_width = 8
var line_color = Color(.1, .1, .1, 1)

# Number starting at 1, at 2 bullets start. 
# Each completed level increases difficulty by one
# Number of bulletspawners is (difficulty - 1)
# Number of traps is 8 + difficulty per player color
var difficulty = 2

var trap_scene = preload("res://entities/trap/trap.tscn")
var tile_scene = preload("res://world/tile/tile.tscn")
var bullet_scene = preload("res://entities/bullet/bullet.tscn")
var bullet_spawner_scene = preload("res://entities/bullet/bullet_spawner.tscn")
var goal_scene = preload("res://entities/goal/goal.tscn")

var local_player


func add_temp_trap(at_tile: Vector2, type: String):
	var trap = trap_scene.instantiate()
	# trap = $Spawner.spawn(trap_scene)
	add_child(trap, true)
	var at_pos = tile_to_world_coord(at_tile)
	traps[at_tile] = trap
	trap.position = at_pos
	trap.modulate = Color.RED if type == "red" else Color.BLUE
	# trap.visible = local_player == "red"
	trap.type = type
	trap.tile = at_tile
	trap.add_to_group("temp_trap")


func add_trap(at_tile: Vector2, type: String):
	var trap = trap_scene.instantiate()
	# trap = $Spawner.spawn(trap_scene)
	
	var at_pos = tile_to_world_coord(at_tile)
	traps[at_tile] = trap
	trap.position = at_pos
	trap.modulate = Color.RED if type == "red" else Color.BLUE
	# trap.visible = local_player == "red"
	trap.type = type
	trap.tile = at_tile
	add_child(trap, true)
	print(traps)


func add_random_traps(number: int, type: String):
	for i in number:
		var at_tile
		while true:
			at_tile = random_tile()
			if at_tile not in traps and at_tile not in [Vector2(0, 0), map_size - Vector2.ONE]:
				break
		
		var trap_positions = get_trap_positions()
		trap_positions.append(at_tile)
		if can_reach_other_player(trap_positions):
			add_trap(at_tile, type)


func add_random_bullet_spawner(type: String):
	var bullet_spawner = bullet_spawner_scene.instantiate()
	# trap = $Spawner.spawn(trap_scene)
	var at_tile = Vector2(-1, randi_range(1, map_size.y-2))
	var at_pos = tile_to_world_coord(at_tile)
	bullet_spawner.position = at_pos
	# trap.modulate = Color.RED if type == "red" else Color.BLUE
	# trap.visible = local_player == "red"
	bullet_spawner.type = type
	add_child(bullet_spawner, true)


func start_game():
	$Waiting.visible = false
	add_random_traps(12, "red")
	add_random_traps(12, "blue")
	add_random_bullet_spawner("red")
	add_random_bullet_spawner("blue")
	for player in get_tree().get_nodes_in_group("players"):
		# print("goal at ", player.position)
		var goal = goal_scene.instantiate()
		add_child(goal, true)
		goal.position = player.position
		
		if player.type == "blue":
			goal.type = "red"
		elif player.type == "red":
			goal.type = "blue"
		else:
			printerr("Could not determine player type!")
		
		goal.modulate = Color.RED if goal.type == "red" else Color.BLUE
	
	for y in map_size.y:
		for x in map_size.x:
			var tile = tile_scene.instantiate()
			add_child(tile, true)
			tile.position = tile_to_world_coord(Vector2(x, y))
	
	# Call deferred is important here because otherwise godot does not have enough
	# time to sync traps with the other player
	call_deferred("rpc", "sync_traps")


func local_player_type():
	return $Multiplayer.local_player_character.type

@rpc
func is_tile_deadly(tile_coord):
	print(tile_coord in traps)
	print(traps)
	return tile_coord in traps


func is_tile_occupied(tile) -> bool:
	for player in get_tree().get_nodes_in_group("players"):
		# print(player.tile)
		if (player.tile - tile).length() < 0.1:
			return true
	return false


func is_legal_tile_coord(tile_coord) -> bool:
	return 0 <= tile_coord.x and tile_coord.x < map_size.x and 0 <= tile_coord.y and tile_coord.y < map_size.y


func clamp_tile_coord(tile) -> Vector2:
	return round_vec2(Vector2(clamp(tile.x, 0, map_size.x-1), clamp(tile.y, 0, map_size.y-1)))


func round_vec2(vec) -> Vector2:
	return Vector2(round(vec.x), round(vec.y))


func tile_to_world_coord(tile_coord) -> Vector2:
	return tile_coord * box_size + Vector2.ONE * box_size / 2 - map_size / 2 * box_size


func world_to_tile_coord(world_coord) -> Vector2:
	var tile_coord = (world_coord + map_size / 2 * box_size - Vector2.ONE * box_size / 2) / box_size
	return Vector2(round(tile_coord.x), round(tile_coord.y))


func random_tile() -> Vector2:
	return Vector2(randi_range(0, map_size.x-1), randi_range(0, map_size.y-1))


func can_reach_other_player(trap_positions: Array[Vector2]):
	var visited_tiles = []
	var tile_queue = []
	var start_tile = Vector2(0, 0)
	var end_tile = Vector2(9, 9)
	
	visited_tiles.append(start_tile)
	tile_queue.append(start_tile)
	
	while tile_queue:
		var current_tile = tile_queue.pop_front()
		var neighbors = get_neighbors_for_tile(current_tile, trap_positions)
		
		for neighbor in neighbors:
			if neighbor not in visited_tiles:
				visited_tiles.append(neighbor)
				tile_queue.append(neighbor)
			
	if end_tile in visited_tiles:
		return true
	else:
		return false


func get_neighbors_for_tile(current_tile: Vector2, trap_positions: Array[Vector2]):
	var neighbors = []
	neighbors.append(Vector2(current_tile.x - 1, current_tile.y))
	neighbors.append(Vector2(current_tile.x + 1, current_tile.y))
	neighbors.append(Vector2(current_tile.x, current_tile.y - 1))
	neighbors.append(Vector2(current_tile.x, current_tile.y + 1))
	
	var valid_neighbors = []
	
	for neighbor in neighbors:
		if is_point_in_map(neighbor) and not neighbor in trap_positions:
			valid_neighbors.append(neighbor)
			
	return valid_neighbors


func is_point_in_map(point: Vector2) -> bool:
	if point.x >= 0 and point.x < map_size.x and point.y >= 0 and point.y < map_size.y:
		return true
	return false


func get_trap_positions() -> Array[Vector2]:
	var trap_positions: Array[Vector2] = []
	
	for trap in traps:
		trap_positions.append(trap)
		
	return trap_positions


@rpc("call_local","reliable")
func sync_traps():
	var local_type = $Multiplayer.local_player_character.type
	for trap in get_tree().get_nodes_in_group("trap"):
		trap.visible = local_type == trap.type
		# print(trap.type, " | ", local_type, " -> ", trap.type == local_type)
		# trap.visible = trap.type == type


@rpc("any_peer", "call_local", "reliable")
func set_game_paused(state: bool) -> void:
	is_game_paused = state


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	Globals.did_show_intro = true
