extends Node
class_name Inventory

signal item_added(item: ItemData)
signal item_removed(item: ItemData)
signal inventory_changed

const MAX_SLOTS = 16

var items: Array[ItemData] = []

func _ready() -> void:
	items.resize(MAX_SLOTS)

func add_item(item: ItemData) -> bool:
	if items.size() >= MAX_SLOTS:
		return false
	var item_exist = items.has(item)
	print(item_exist)
	if(item_exist and item.can_stack):
		item.amount += 1
	else:
		items.append(item)
	item_added.emit(item)
	inventory_changed.emit()
	return true

func remove_item(item: ItemData) -> void:
	var item_exist = items.has(item)
	if(item_exist and item.can_stack and item.amount > 1):
		item.amount -= 1
	else:
		items.erase(item)
	item_removed.emit(item)
	inventory_changed.emit()

func has_tool(tool_type: String) -> bool:
	return items.any(func(i): return i.tool_type == tool_type)

func consume_tool(tool_type: String) -> void:
	var tool = items.filter(func(i): return i.tool_type == tool_type).front()
	if tool:
		remove_item(tool)

func get_total_value() -> int:
	return items.reduce(func(acc, i): return acc + i.value, 0)
