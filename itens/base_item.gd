extends Node2D
class_name Item
@export var data: ItemData

@export var interactableArea: InteractableObject

func _ready() -> void:
	if(interactableArea != null):
		interactableArea.connect("interacted", on_interaction)

func on_interaction(player: Player):
	player.inventory.add_item(data)
	queue_free()
