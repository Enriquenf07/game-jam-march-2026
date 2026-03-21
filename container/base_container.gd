extends StaticBody2D
class_name BaseContainer
@export var object: InteractableObject
@export var time_to_open: int = 1
@export var need_key: bool = false
@export var key_id: int = 0
@export var item_data: ItemData
@onready var packed_item = preload("res://itens/Item.tscn")


func _ready() -> void:
	assert(object != null, 'Object is null')
	


func _on_interactable_object_interacted(player: Player) -> void:
	if(need_key):
		var items = player.inventory.items
		var key_index = items.find_custom(func(i):
			return i.id == key_id
		)
		if key_index > -1:
			var key = items.get(key_index)
			player.inventory.remove_item(key)
		else:
			return
	var item = packed_item.instantiate() as Item
	item.data = item_data
	item.global_position = global_position
	add_sibling(item)
	queue_free()
