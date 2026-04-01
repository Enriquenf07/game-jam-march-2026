extends CanvasLayer
class_name Hud

@export var money_label: Label
var _money: int
@export var police_timer: EscapeTimer

func _ready() -> void:
	LootEventBus.connect("loot_collected", _on_loot_collected)

func _on_loot_collected(loot_value: int):
	_money += loot_value
	money_label.text = "Money: $" + str(_money)
