extends CharacterBody2D

@export var speed = 400

var movement_delay = 0.3
var next_allowed_movement_time = -1

func _ready():
	name = str(get_multiplayer_authority())

	# print("Player spawned. Position: %s" % [position])

func time():
	return Time.get_unix_time_from_system()

func _physics_process(_delta):
	if is_multiplayer_authority():
		# look_at(get_viewport().get_mouse_position())
		
		var direction = Input.get_vector("left", "right", "up", "down")
		
		if direction.x != 0:
			direction.y = 0
		
		if direction.length() != 0 and next_allowed_movement_time <= time():
			var new_position = position + direction * 100
			get_tree().create_tween().tween_property(self, "position", new_position, movement_delay) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			
			var animation_scale = Vector2(0.9, 0.9) + (direction * direction) * 0.4
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale", animation_scale, movement_delay / 3) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "scale", Vector2.ONE, movement_delay / 3 * 2) \
				.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
				
			next_allowed_movement_time = time() + movement_delay
		
		# velocity = direction * speed

		# move_and_slide()

		# rpc("remote_set_position", global_position)
		remote_set_position.rpc(global_position)
		
		remote_set_scale.rpc(global_scale)
		#remote_set_rotation.rpc(global_rotation)

@rpc("unreliable")
func init_as_player(color, pos):
	$BodySprite.self_modulate = color
	position = pos
	remote_set_position(global_position)

@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position


@rpc("unreliable")
func remote_set_rotation(authority_rotation):
	global_rotation = authority_rotation

@rpc("unreliable")
func remote_set_scale(authority_scale):
	global_scale = authority_scale
