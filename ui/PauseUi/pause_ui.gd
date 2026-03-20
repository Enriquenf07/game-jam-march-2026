extends CanvasLayer
class_name PauseUI
@export var tabContainer: TabContainer
@export var inventory_ui: InventoryUI

func refresh_inventory():
	inventory_ui.refresh()

func change_inventory(inventory: Inventory):
	inventory_ui.inventory = inventory

# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed('pause')):
		if(tabContainer.current_tab == 0):
			visible = !visible
			return
		tabContainer.current_tab = 0
		visible = true
	if(event.is_action_pressed('open_inventory')):
		if(tabContainer.current_tab == 1):
			visible = !visible
			return
		tabContainer.current_tab = 1
		visible = true
