Extends Node
class_name State

var entity: Enemy

func set_entity(entity: Enemy) -> void:
    self.entity = entity

func get_entity() -> Enemy:
    return entity

func enter() -> void:
    pass

func exit() -> void:
    pass

func update(delta: float) -> void:  
    pass

