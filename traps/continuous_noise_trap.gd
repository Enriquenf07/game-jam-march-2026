class_name ContinuousNoiseTrap
extends TrapBase

var _player_in_trap: Player
var _is_in_trap: bool = false
@export var _trap_audio_collision: CollisionShape2D

func _process(_delta: float) -> void:
	if (not _is_in_trap or not _player_in_trap.velocity or _trap_trigger_sound.playing):
		return
	_trap_trigger_sound.play()
	_trap_audio_collision.set_deferred("disabled", false)

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	if (not body.is_in_group("player")):
		return
	_player_in_trap = body
	_is_in_trap = true
	_trap_audio_collision.set_deferred("disabled", false)

func _on_body_exited(body: Node2D) -> void:
	if (not body.is_in_group("player") or body != _player_in_trap):
		return
	_player_in_trap = null
	_is_in_trap = false

func _on_trap_activation_sound_finished() -> void:
	_trap_audio_collision.set_deferred("disabled", true)
