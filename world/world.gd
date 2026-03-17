extends Node2D
class_name World

@export var lerp_speed: float = 5.
@export var hud: Hud
@export var camera: Camera2D
@export var canvaModulate: CanvasModulate
var player: Player
var inventory = Inventory.new()

func _ready() -> void:
	if(canvaModulate == null):
		assert(canvaModulate != null, 'The world doesn’t have a canvas modulate.')
	canvaModulate.color = Color.BLACK
	_refresh()
	var factory := PlayerFactory.new()
	player = factory.create(Vector2(0, 0), self, inventory)
	inventory.inventory_changed.connect(_refresh)

func _refresh() -> void:
	var weight := 0.0
	for item in inventory.items:
		weight += item.weight
	hud.weight_label.text = "Weight: %.2f" % weight

func _physics_process(delta: float) -> void:
	if(player != null):
		var target_pos = player.global_position
		camera.global_position = camera.global_position.lerp(target_pos, lerp_speed * delta)
