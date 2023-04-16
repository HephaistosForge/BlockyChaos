extends CharacterBody2D

@export var speed = 400
@export var tile: Vector2 = Vector2.ZERO

var movement_delay = 0.3
var next_allowed_movement_time = -1
var world: Node2D
var type: String

var _initial_scale: Vector2
var _initial_rotation: float
@export var goal_reached = false

const BACK_TO_MENU_DIALOG = preload("res://ui/back_to_menu_dialog/back_to_menu_dialog.tscn")

func _ready():
	name = str(get_multiplayer_authority())
	self.add_to_group("players")
	
	_initial_scale = scale
	_initial_rotation = rotation
	
	# print("Player spawned. Position: %s" % [position])


func time():
	return Time.get_unix_time_from_system()


func die():
	world.rpc("set_game_paused", true)
	
	$AudioWrong.play()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, .05) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(self, "rotation", 2 * PI, 1) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).from_current()
	tween.parallel().tween_property(self, "scale", Vector2.ONE * .2, 1) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	# Bug Fix: Clicking "Ready" Button too early before tween animation is
	# done causes Player to be resetted "inside the animation"
	# Therefore, await
	await get_tree().create_timer(1.0).timeout
	
	$death.emitting = true
	rpc("display_big_floating_message", Globals.GAME_OVER_TEXT)


func win():
	# Ideas, Tweens:
	# Center to player position
	# Zoom slightly in
	world.rpc("set_game_paused", true)
	rpc("display_big_floating_message", Globals.WINNING_TEXT)


func _physics_process(_delta):
	if is_multiplayer_authority() and !world.is_game_paused:
		var direction = Input.get_vector("left", "right", "up", "down")
		
		# Ensure that you cannot move diagonally
		if direction.x != 0:
			direction.y = 0
		
		if direction.length() != 0 and next_allowed_movement_time <= time():
			var new_tile = world.round_vec2(tile + direction)
			
			var _can_move_there = world.is_legal_tile_coord(new_tile) and not world.is_tile_occupied(new_tile)
			
			if _can_move_there:
				$AudioMove.play()
				tile = new_tile
				var _is_on_deadly_tile: bool = world.is_tile_deadly(tile)
			
				var new_position = world.tile_to_world_coord(tile)
				get_tree().create_tween().tween_property(self, "position", new_position, movement_delay) \
					.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
				
				# Squish animation while moving
				var animation_scale = Vector2(0.9, 0.9) + (direction * direction) * 0.4
				var tween = get_tree().create_tween()
				tween.tween_property(self, "scale", animation_scale, movement_delay / 3) \
					.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
				tween.tween_property(self, "scale", Vector2.ONE, movement_delay / 3 * 2) \
					.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
				if _is_on_deadly_tile:
					var trap_color = "red" if type == "blue" else "blue"
					get_tree().get_root().get_node("World").add_temp_trap(tile, trap_color)
					#print(world.traps[tile])
					#self.add_child(instance_from_id(world.traps[tile].object_id))#.rpc("fade_in") # NullPointerException
					
					die()
				
				next_allowed_movement_time = time() + movement_delay
			else:
				$AudioWrong.play()
				var tween = get_tree().create_tween()
				var angle = 0.2
				var anim_time = 0.1
				
				# Rotation animation when blocked by something
				tween.tween_property(self, "rotation", angle, anim_time) \
					.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
				tween.tween_property(self, "rotation", -angle, anim_time) \
					.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
				tween.tween_property(self, "rotation", 0, anim_time) \
					.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)


func check_if_won():
	var won = true
	for player in get_tree().get_nodes_in_group("player"):
		won = won and player.goal_reached
	if won:
		win()


@rpc("any_peer")
func init_as_player(color, tile_coord, player_type: String):
	$Body/BodySprite.self_modulate = color
	
	self.type = player_type
	#if is_multiplayer_authority():
	# Globals.local_player_type = type
	
	tile = tile_coord
	world = get_tree().get_first_node_in_group("world")
	position = world.tile_to_world_coord(tile)


func restart() -> void:
	# "Manual" restart, session is kept
	$death.emitting = false
	
	tile = Vector2.ZERO if type == "red" else Vector2.ONE * get_parent().get_parent().map_size - Vector2.ONE
	
	position = world.tile_to_world_coord(tile)
	scale = _initial_scale
	rotation = _initial_rotation
	
	world.rpc("set_game_paused", false)
	rpc("hide_big_floating_message")


func _input(event):
	if event is InputEventMouseMotion and is_multiplayer_authority():
		var lefteye = $Body/LeftEye.get_global_position()
		var righteye = $Body/RightEye.get_global_position()
		$Body/LeftEye/LeftEyePupil.set_global_position(lefteye + \
			(event.position - Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2) - lefteye).normalized() * 4)
		$Body/RightEye/RightEyePupil.set_global_position(righteye + \
			(event.position - Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2) - righteye).normalized() * 4)
	if event.is_action_pressed("back_to_menu") and is_multiplayer_authority():
		show_back_to_menu_dialog()


func show_back_to_menu_dialog():
	var dialog = BACK_TO_MENU_DIALOG.instantiate()
	dialog.peer = multiplayer.get_unique_id()
	get_tree().get_root().add_child(dialog)
	


@rpc("any_peer", "call_local", "reliable")
func display_big_floating_message(text) -> void:
	Globals.display_big_floating_message(text)


@rpc("any_peer", "call_local", "reliable")
func hide_big_floating_message() -> void:
	Globals.hide_big_floating_message()
