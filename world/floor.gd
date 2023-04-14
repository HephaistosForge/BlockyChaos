extends Node2D

var map_size = Vector2(10, 10)
var box_size = 100
var line_width = 7
var line_color = Color(.1, .1, .1, .9)
var font = ThemeDB.fallback_font


func line(from, to):
	draw_line(from, to, line_color, line_width, true)

func _draw():
	for y in map_size.y+1:
		var from = Vector2(map_size.x * box_size / 2, (y - map_size.y / 2) * box_size)
		line(from, from * Vector2(-1, 1))
		
	for x in map_size.x+1:
		var from = Vector2((x - map_size.x / 2) * box_size, map_size.y * box_size / 2)
		line(from, from * Vector2(1, -1))

	# Debug info
	for y in map_size.y:
		for x in map_size.x:
			var at = tile_to_world_coord(Vector2(x, y))
			draw_string(font, at, "(%d, %d)" % [x, y])
			
			
# Coordinates

func is_tile_occupied(tile):
	for player in get_tree().get_nodes_in_group("player"):
		print(player.tile)
		if (player.tile - tile).length() < 0.1:
			return true
	return false

func is_legal_tile_coord(tile_coord):
	return 0 <= tile_coord.x and tile_coord.x < map_size.x and 0 <= tile_coord.y and tile_coord.y < map_size.y
	
func clamp_tile_coord(tile):
	return round_vec2(Vector2(clamp(tile.x, 0, map_size.x-1), clamp(tile.y, 0, map_size.y-1)))
	
func round_vec2(vec):
	return Vector2(round(vec.x), round(vec.y))

func tile_to_world_coord(tile_coord):
	return tile_coord * box_size + Vector2.ONE * box_size / 2 - map_size / 2 * box_size
	
func world_to_tile_coord(world_coord):
	var tile_coord = (world_coord + map_size / 2 * box_size - Vector2.ONE * box_size / 2) / box_size
	return Vector2(round(tile_coord.x), round(tile_coord.y))
	
