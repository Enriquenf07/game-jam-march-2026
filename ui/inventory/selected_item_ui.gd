extends HBoxContainer
class_name SelectedItemUI
@export var texture: TextureRect
@export var weight: Label
@export var value: Label
@export var name_label: Label


func change_item(item: ItemData):
	if(item == null):
		visible = false
		return
	visible = true
	texture.texture = item.icon
	name_label.text = item.display_name
	weight.text = str(item.weight)
	value.text = str(item.value)

signal drop_item

func _on_drop_item_pressed() -> void:
	drop_item.emit()
