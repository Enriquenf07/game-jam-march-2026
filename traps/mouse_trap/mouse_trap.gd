class_name MouseTrap
extends NoisyTrap

var _disarmed_texture = preload("res://assets/TEMP_mouse_trap_disarmed.png")
@export var _player_hurt_sound: AudioStreamPlayer2D
@export var _player_hurt_collision: CollisionShape2D

func _disarm_decorator():
	print("mouse traps disarmed")

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	if (not body.is_in_group("player") or not body.has_method("handle_trap_activation")):
		return
	_player_hurt_sound.play()
	_player_hurt_collision.set_deferred("disabled", false)
	_trap_visual.texture = _disarmed_texture

func _on_trap_disarmed():
	_trap_trigger_sound.play()
	_trap_audio_collision.set_deferred("disabled", false)
	_trap_visual.texture = _disarmed_texture

func _on_player_hurt_sound_player_finished() -> void:
	_trap_trigger_collision.set_deferred("disabled", true)
	_player_hurt_collision.set_deferred("disabled", true)
