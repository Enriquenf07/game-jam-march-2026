class_name marbles
extends NoisyTrap

func _disarm_decorator():
	print("marbles disarmed")

func _on_trap_disarmed():
	trap_visual.hide()

func _on_disarm_sound_player_finished() -> void:
	queue_free()
