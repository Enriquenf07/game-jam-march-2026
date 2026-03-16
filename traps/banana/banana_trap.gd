extends TrapBase
class_name BananaTrap

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	
func _disarm_decorator():
	print('banana disarmed')

func _on_trap_disarmed() -> void:
	_trap_visual.hide()
