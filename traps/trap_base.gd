class_name TrapBase
extends Area2D

enum TrapType {FLOORBOARD, BANANA, MARBLES, MOUSE_TRAP, PUDDLE}

@export var _type_of_trap: TrapType
@export var _trap_visual: Sprite2D
@export var _trap_trigger_collision: CollisionShape2D
@export var _disarm_sound: AudioStreamPlayer
@export var time_to_disable: float = 1.0

func _ready() -> void:
	assert((time_to_disable > 0.0), name + " has a disable time of 0 or less!")

func _on_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("player") || !body.has_method("handle_trap_activation")):
		return
	# Call a function in the player script to handle what happens
	body.handle_trap_activation(_type_of_trap)

func _disarm_decorator():
	pass

func _disarm() -> void:
	_trap_trigger_collision.set_deferred("disabled", true)
	_disarm_sound.play()
	_disarm_decorator()
