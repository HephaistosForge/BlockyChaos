extends Node2D

var map_size = Vector2(5, 5)
var box_size = 200
@onready var line_width = get_parent().get_parent().line_width
var font = ThemeDB.fallback_font

func line(from, to):
	draw_line(from, to, get_parent().get_parent().line_color, line_width, true)

func _draw():
	for y in map_size.y+1:
		var from = Vector2(map_size.x * box_size / 2 + line_width / 2, (y - map_size.y / 2) * box_size)
		line(from, from * Vector2(-1, 1))
		
	for x in map_size.x+1:
		var from = Vector2((x - map_size.x / 2) * box_size, map_size.y * box_size / 2)
		line(from, from * Vector2(1, -1))

	# Debug info
	#for y in map_size.y:
	#	for x in map_size.x:
	#		var at = get_parent().tile_to_world_coord(Vector2(x, y))
			# draw_string(font, at, "(%d, %d)" % [x, y])
			
			
