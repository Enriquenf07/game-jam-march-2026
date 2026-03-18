class_name Floorboard
extends ContinuousNoiseTrap

var _disarmed_texture: Texture = preload("res://traps/floorboard/assets/TEMP_floorboard_disarmed.png")

func _disarm_decorator():
	print("floorboard disarmed")

func _on_trap_disarmed() -> void:
	_trap_visual.texture = _disarmed_texture
