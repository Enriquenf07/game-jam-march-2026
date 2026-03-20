class_name Floorboard
extends ContinuousNoiseTrap

@export var _squeak_sounds: Array[AudioStream]
var _disarmed_texture: Texture = preload("res://traps/floorboard/floor_-_wooden_planks_normal_-_64x64.png")

func _ready() -> void:
	super._ready()
	_trap_trigger_sound.stream = _squeak_sounds[randi_range(0, _squeak_sounds.size() - 1)]

func _disarm_decorator():
	print("floorboard disarmed")

func _on_trap_disarmed() -> void:
	_trap_visual.texture = _disarmed_texture

func _on_trap_activation_sound_finished() -> void:
	_trap_trigger_sound.stream = _squeak_sounds[randi_range(0, _squeak_sounds.size() - 1)]
	super._on_trap_activation_sound_finished()
