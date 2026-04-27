extends State
class_name Patrol

const ARRIVE_DISTANCE: float = 10.0
const WAIT_TIME: float = 2.0

var current_point: int = 0
var wait_timer: float = 0.0
var waiting: bool = false

func enter() -> void:
	print("Entering Patrol State")
	waiting = false
	wait_timer = 0.0
	if entity.patrol_positions.is_empty():
		return
	entity.nav.target_position = entity.patrol_positions[current_point]

func exit() -> void:
	print("Exiting Patrol State")

func update(delta: float) -> void:
	if entity.patrol_positions.is_empty():
		return
	if entity.vision_cone.is_colliding():
		_check_for_player_in_vision()
	else:
		entity.vision.set_deferred("enabled", false)
	if entity.vision.is_colliding():
		if entity.vision.get_collider().is_in_group("player"):
			entity.change_state("chase")
			return
	var bodies = entity.areaOfSound.get_overlapping_areas()
	var sound_bodies = bodies.filter(func(b): return b.is_in_group("sound"))
	if not sound_bodies.is_empty():
		entity.sound_target = sound_bodies[0].global_position  
		entity.change_state("investigate")
		return
	if waiting:
		_wait_at_patrol_point(delta)
		return
	if entity.nav.is_navigation_finished():
		waiting = true
		entity.velocity = Vector2.ZERO
		return
	_move_to_next_point()

func _check_for_player_in_vision() -> void:
	var player_found: bool = false
	for i in entity.vision_cone.get_collision_count():
		if (entity.vision_cone.get_collider(i).is_in_group("player")):
			player_found = true
			var vision_direction: Vector2 = (entity.vision_cone.get_collider(i).global_position - entity.global_position).normalized()
			entity.vision.target_position = vision_direction * entity.ray_length
	entity.vision.set_deferred("enabled", player_found)

func _wait_at_patrol_point(delta: float) -> void:
	wait_timer += delta
	if wait_timer >= WAIT_TIME:
		waiting = false
		wait_timer = 0.0
		current_point = (current_point + 1) % entity.patrol_positions.size()
		entity.nav.target_position = entity.patrol_positions[current_point]

func _move_to_next_point():
	var next = entity.nav.get_next_path_position()
	var direction = (next - entity.global_position).normalized()
	entity.velocity = direction * entity.speed
	entity.vision_cone.rotation_degrees = 0.0
	entity.vision_cone.look_at(next)
	entity.vision_cone.rotation_degrees += 90.0
	entity.move_and_slide()
