extends Node2D

@export var type: String
var bullet_scene = preload("res://entities/bullet/bullet.tscn")

@onready var world = get_tree().get_first_node_in_group("world")

var wait_time = 4 + randf() * 4

func _ready():
	$Timer.wait_time = randf_range(0, wait_time)
	$Timer.start()
	await $Timer.timeout
	$Timer.wait_time = wait_time
	$Timer.start()

func _on_timer_timeout():
	var bullet = bullet_scene.instantiate()
	bullet.modulate = Color.RED if type == "red" else Color.BLUE
	bullet.type = type
	bullet.position = position
	bullet.rotation = rotation
	get_parent().add_child(bullet, true)
	var tween = bullet.create_tween()
	tween.tween_property(bullet, "position", $Target.global_position, 6)
	tween.tween_callback(bullet.queue_free)
