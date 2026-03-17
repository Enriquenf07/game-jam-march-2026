class_name NoisyTrap
extends TrapBase

@export var _trap_audio_collision: CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	_trap_audio_collision.set_deferred("disabled", false)

func _on_trap_activation_sound_finished() -> void:
	_trap_audio_collision.set_deferred("disabled", true)
