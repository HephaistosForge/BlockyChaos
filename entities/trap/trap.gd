extends Node2D

const FADE_DURATION = 3.0

@export var type: String

@onready var sawblade_sprite: Sprite2D = $SawbladeSprite

var _initial_visibility: bool
var tile: Vector2

func _ready():
	_initial_visibility = self.visible
	
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "rotation", 500, 2 + randf() * 2).from_current() \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation", 0, randf()).from_current()
	
	# self.visible = type != Globals.local_player_type


@rpc("any_peer", "call_local", "reliable")
func fade_in() -> void:
	self.visible = true
	sawblade_sprite.modulate = 0
		
	create_tween() \
		.tween_property(sawblade_sprite, "modulate", Color(Color.WHITE, 1.0), FADE_DURATION) \
		.from(sawblade_sprite.modulate) \
		.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)

 
@rpc("any_peer", "call_local", "reliable")
func fade_out() -> void:
	create_tween() \
		.tween_property(sawblade_sprite, "modulate", Color(Color.WHITE, 0.0), FADE_DURATION) \
		.from(sawblade_sprite.modulate) \
		.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	
	self.visible = false
