extends Area2D
class_name InteractableObject

signal interacted


func on_interaction():
	interacted.emit()

	
