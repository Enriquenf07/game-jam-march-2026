extends Node2D
@export var lerp_speed: float = 5.
@onready var camera := %Camera
var player: Player

func _ready() -> void:
	var factory := PlayerFactory.new()
	player = factory.create(Vector2(0, 0), self)
	pass 

func _physics_process(delta: float) -> void:
	if(player != null):
		var target_pos = player.global_position
		camera.global_position = camera.global_position.lerp(target_pos, lerp_speed * delta)
