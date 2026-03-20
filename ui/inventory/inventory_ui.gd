extends TabBar
class_name InventoryUI
@export var grid: GridContainer
@export var selected_item_ui: SelectedItemUI
var inventory: Inventory

var slots_text: Array[TextureRect] = [
]

var slots_label: Array[Label] = [
]

var selected_item: ItemData



func _create_rect():
	var texture_rect = TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(100, 100)
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	return texture_rect

func _create_bg():
	var rect = ColorRect.new()
	rect.custom_minimum_size = Vector2(100, 100)
	rect.color = Color.ANTIQUE_WHITE
	return rect

func _create_button(index):
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(100, 100)
	btn.pressed.connect(func():
		_on_pressed(index)
	)
	return btn

func _create_amount_label():
	var label = Label.new()
	return label

func _on_pressed(index):
	if (inventory.items.size() == 0):
		return
	selected_item = inventory.items.get(index)
	selected_item_ui.change_item(selected_item)

func _on_drop_item():
	inventory.remove_item(selected_item)

func _ready() -> void:
	selected_item_ui.drop_item.connect(_on_drop_item)
	_clear() 
	for i in range(inventory.MAX_SLOTS):
		var panel = Panel.new()
		var text_rect = _create_rect()
		var bg_rect = _create_bg()
		var btn = _create_button(i)
		var label = _create_amount_label()
		slots_text.append(text_rect)
		slots_label.append(label)
		panel.add_child(bg_rect)
		panel.add_child(text_rect)
		panel.add_child(btn)
		panel.add_child(label)
		panel.custom_minimum_size = Vector2(100, 100)
		grid.add_child(panel)
		
func _clear():
	for child in grid.get_children():
		if child is ColorRect or child is TextureRect: 
			child.queue_free()  

func refresh() -> void:
	print("refresh", inventory)
	if inventory == null:
		return
	selected_item_ui.visible = false
	if (inventory.items.size() == 0):
		return
	for i in range(inventory.MAX_SLOTS):
		var item = inventory.items.get(i)
		var text = slots_text.get(i)
		var amount = slots_label.get(i)
		if text == null:
			continue
		text.texture = item.icon if item != null else null
		if amount == null:
			continue
		amount.text = str(item.amount) if item != null else ''
