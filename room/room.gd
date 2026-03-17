extends TileMapLayer
class_name Room

@export var room_area: Area2D

func _ready() -> void:
	room_area.body_entered.connect(_on_body_entered)
	room_area.body_exited.connect(_on_body_exit)

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group('player')):
		visible = true
		
func _on_body_exit(body: Node2D) -> void:
	if(body.is_in_group('player')):
		visible = false
