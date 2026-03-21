extends State
class_name Chase

var lost_player_timer: float = 0.0
@export var LOST_PLAYER_TIMEOUT: float = 2.0

func enter() -> void:
	LootEventBus.emit_signal("danger_entered")
	print("Entering Chase State")

func exit() -> void:
	print("Exiting Chase State")

func _check_is_closer():
	var bodies_close = entity.areaOfDanger.get_overlapping_bodies()
	var player_close = bodies_close.filter(func(b): return b.is_in_group("player")).front()
	if player_close:
		print('close')
		entity.get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
		return

func _chase(delta: float) -> void:
	var bodies = entity.areaOfChasing.get_overlapping_bodies()
	var player = bodies.filter(func(b): return b.is_in_group("player")).front()
	if player:
		lost_player_timer = 0.0
		entity.nav.target_position = player.global_position

		if entity.nav.is_navigation_finished():
			return

		var next = entity.nav.get_next_path_position()
		var direction = (next - entity.global_position).normalized()
		entity.velocity = direction * entity.speed
		entity.vision.target_position = direction * entity.ray_length
		entity.move_and_slide()
	else:
		lost_player_timer += delta
		entity.velocity = Vector2.ZERO
		if lost_player_timer >= LOST_PLAYER_TIMEOUT:
			entity.change_state("patrol")

func update(delta: float) -> void:
	_check_is_closer()
	_chase(delta)
