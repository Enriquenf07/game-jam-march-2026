extends Node
class_name Inventory

signal item_added(item: ItemData)
signal item_removed(item: ItemData)
signal inventory_changed

const MAX_SLOTS = 12

var items: Array[ItemData] = []

func add_item(item: ItemData) -> bool:
	if items.size() >= MAX_SLOTS:
		return false
	items.append(item)
	item_added.emit(item)
	inventory_changed.emit()
	return true

func remove_item(item: ItemData) -> void:
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
