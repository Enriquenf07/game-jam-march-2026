extends State
class_name Investigate

const ARRIVE_DISTANCE: float = 10.0
const WAIT_TIME: float = 3.0

var wait_timer: float = 0.0
var arrived: bool = false

func enter() -> void:
	print("Entering Investigate State")
	wait_timer = 0.0
	arrived = false
	entity.nav.target_position = entity.sound_target

func exit() -> void:
	print("Exiting Investigate State")

func update(delta: float) -> void:
	if entity.vision_cone.is_colliding():
		_check_for_player_in_vision()
	else:
		entity.vision.set_deferred("enabled", false)
	if entity.vision.is_colliding():
		if entity.vision.get_collider().is_in_group("player"):
			entity.change_state("chase")
			return
	_move_to_next_point()
	if not arrived:
		if entity.nav.is_navigation_finished():
			arrived = true
			entity.velocity = Vector2.ZERO
			return
	else:
		wait_timer += delta
		if wait_timer >= WAIT_TIME:
			entity.change_state("patrol")

func _check_for_player_in_vision() -> void:
	var player_found: bool = false
	for i in entity.vision_cone.get_collision_count():
		if (entity.vision_cone.get_collider(i).is_in_group("player")):
			player_found = true
			var vision_direction: Vector2 = (entity.vision_cone.get_collider(i).global_position - \
			entity.global_position).normalized()
			entity.vision.target_position = vision_direction * entity.ray_length
	entity.vision.set_deferred("enabled", player_found)

func _move_to_next_point() -> void:
	var next = entity.nav.get_next_path_position()
	var direction = (next - entity.global_position).normalized()
	entity.velocity = direction * entity.speed
	entity.vision_cone.rotation_degrees = 0.0
	entity.vision_cone.look_at(next)
	entity.vision_cone.rotation_degrees += 90.0
	entity.move_and_slide()
