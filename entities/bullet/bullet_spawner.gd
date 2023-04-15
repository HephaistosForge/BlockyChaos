extends Node2D

@export var type: String
var bullet_scene = preload("res://entities/bullet/bullet.tscn")

func _on_timer_timeout():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet, true)
	bullet.position = position
	var tween = bullet.create_tween()
	tween.tween_property(bullet, "position", $Target.global_position, 5)
	tween.tween_callback(bullet.queue_free)
	
	bullet.modulate = Color.RED if type == "red" else Color.BLUE
	
	
