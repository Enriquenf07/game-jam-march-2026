class_name TrapBase
extends Area2D

signal trap_disarmed()

enum TrapType {FLOORBOARD, BANANA, MARBLES, MOUSE_TRAP, PUDDLE}

@export var _type_of_trap: TrapType
@export var _trap_visual: Sprite2D
@export var _trap_trigger_collision: CollisionShape2D
@export var _disarm_sound: AudioStreamPlayer
@export var _trap_trigger_sound: AudioStreamPlayer2D
@export var time_to_disable: float = 1.0
@export var _trap_interaction_collision: CollisionShape2D
@onready var interactableArea := %InteractableArea

func _ready() -> void:
	assert((time_to_disable > 0.0), name + " has a disable time of 0 or less!")
	interactableArea.connect("interacted", _disarm)

func _on_body_entered(body: Node2D) -> void:
	if (not body.is_in_group("player") or not body.has_method("handle_trap_activation")):
		return
	# Call a function in the player script to handle what happens
	_trap_trigger_sound.play()
	body.handle_trap_activation(_type_of_trap)

func _disarm_decorator():
	pass

func _disarm(player: Player) -> void:
	player.set_is_still(true)
	await get_tree().create_timer(time_to_disable).timeout
	player.set_is_still(false)
	_trap_trigger_collision.set_deferred("disabled", true)
	_trap_interaction_collision.set_deferred("disabled", true)
	if (_type_of_trap != TrapType.MOUSE_TRAP):
		_disarm_sound.play()
	_disarm_decorator()
	trap_disarmed.emit()
