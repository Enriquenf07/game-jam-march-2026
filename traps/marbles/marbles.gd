class_name marbles
extends NoisyTrap

func _disarm_decorator():
	print("marbles disarmed")

func _on_trap_disarmed():
	_trap_visual.hide()
