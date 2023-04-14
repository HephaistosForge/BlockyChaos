extends Node2D

var map_size = Vector2(10, 10)
var box_size = 100
var line_width = 7
var line_color = Color(.1, .1, .1, .9)

func line(from, to):
	draw_line(from, to, line_color, line_width, true)

func _draw():
	for y in map_size.y+1:
		var from = Vector2(map_size.x * box_size / 2, (y - map_size.y / 2) * box_size)
		line(from, from * Vector2(-1, 1))
		
	for x in map_size.x+1:
		var from = Vector2((x - map_size.x / 2) * box_size, map_size.y * box_size / 2)
		line(from, from * Vector2(1, -1))


