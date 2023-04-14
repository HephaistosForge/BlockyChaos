extends Node2D

var map_size = Vector2(10, 10)
var box_size = 100
var line_width = 8
var line_color = Color(.1, .1, .1, 1)

var traps = {}
var trap_scene = preload("res://entities/trap/trap.tscn")
var tile_scene = preload("res://world/tile/tile.tscn")

func add_trap(at_tile: Vector2):
	var trap = trap_scene.instantiate()
	# trap = $Spawner.spawn(trap_scene)
	add_child(trap, true)
	var at_pos = tile_to_world_coord(at_tile)
	trap.position = at_pos
	print(trap.position)
	trap.modulate = Color.RED
	
func add_random_traps(number: int):
	for i in number:
		var at_tile = random_tile()
		print(at_tile)
		add_trap(at_tile)
	
func start_game():
	$Waiting.visible = false
	add_random_traps(10)
	for y in map_size.y:
		for x in map_size.x:
			var tile = tile_scene.instantiate()
			add_child(tile, true)
			tile.position = tile_to_world_coord(Vector2(x, y))
			


# Coordinates

func is_tile_occupied(tile) -> bool:
	for player in get_tree().get_nodes_in_group("player"):
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
	

func is_game_started():
	return len($Multiplayer.connected_peer_ids) >= 1
