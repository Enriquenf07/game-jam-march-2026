extends TrapBase
class_name BananaTrap

@onready var interactableArea := %InteractableArea

func _ready() -> void:
	interactableArea.connect("interacted", _disarm)

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	
func _disarm_decorator():
	print('disarm')
