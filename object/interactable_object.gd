extends Area2D
class_name InteractableObject

signal interacted(interacting_player: Player)

func on_interaction(player: Player):
	interacted.emit(player)
