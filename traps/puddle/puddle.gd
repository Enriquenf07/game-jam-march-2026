class_name Puddle
extends ContinuousNoiseTrap

@export var _slipping_sound_player: AudioStreamPlayer2D
@export var _slipping_sound_collision: CollisionShape2D

func _process(_delta: float) -> void:
	# TODO: call the player method "slip()" if the player is running
	if (_is_running()):
		_slipping_sound_player.play()
		_slipping_sound_collision.set_deferred("disabled", false)
		return
	super._process(_delta)

func _is_running() -> bool:
	# TODO: check if the player is moving, in the trap, and holding the run button
	return false

func _disarm_decorator():
	print("puddle disarmed")

func _on_trap_disarmed():
	_trap_visual.hide()

func _on_slipping_sound_player_finished() -> void:
	_slipping_sound_collision.set_deferred("disabled", true)


func _on_disarm_sound_player_finished() -> void:
	queue_free()
