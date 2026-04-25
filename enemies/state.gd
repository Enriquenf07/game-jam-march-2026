extends Node
class_name State

var entity: Enemy

@warning_ignore("shadowed_variable")
func set_entity(entity: Enemy) -> void:
	self.entity = entity

func get_entity() -> Enemy:
	return entity

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:  
	pass
