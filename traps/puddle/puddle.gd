class_name Puddle
extends ContinuousNoiseTrap

@export var _puddle_step_sounds: Array[AudioStream]
@export var _slipping_sound_player: AudioStreamPlayer2D
@export var _slipping_sound_collision: CollisionShape2D

func _ready() -> void:
	super._ready()
	_trap_trigger_sound.stream = _puddle_step_sounds[randi_range(0, _puddle_step_sounds.size() - 1)]

func _process(_delta: float) -> void:
	if (_player_in_trap != null and _is_running()):
		_player_in_trap.slip_on_puddle()
		_slipping_sound_player.play()
		_slipping_sound_collision.set_deferred("disabled", false)
		return
	super._process(_delta)

func _is_running() -> bool:
	return _player_in_trap.is_running and _player_in_trap.velocity != Vector2.ZERO

func _disarm_decorator():
	print("puddle disarmed")

func _on_trap_activation_sound_finished() -> void:
	super._on_trap_activation_sound_finished()
	_trap_trigger_sound.stream = _puddle_step_sounds[randi_range(0, _puddle_step_sounds.size() - 1)]

func _on_trap_disarmed():
	trap_visual.hide()

func _on_slipping_sound_player_finished() -> void:
	_slipping_sound_collision.set_deferred("disabled", true)

func _on_disarm_sound_player_finished() -> void:
	queue_free()
