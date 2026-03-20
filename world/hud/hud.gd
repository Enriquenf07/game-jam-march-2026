extends CanvasLayer
class_name Hud

@export var weight_label: Label
@export var money_label: Label
@onready var danger_icon := %DangerIcon
var _money: int

func _ready() -> void:
	LootEventBus.connect("loot_collected", _on_loot_collected)
	LootEventBus.connect("danger_entered", _on_danger_entered)
	LootEventBus.connect("danger_exited", _on_danger_exited)

func _on_danger_entered():
	danger_icon.visible = true

func _on_danger_exited():
	danger_icon.visible = false

func _on_loot_collected(loot_value: int):
	_money += loot_value
	money_label.text = "Money: $" + str(_money)
	
