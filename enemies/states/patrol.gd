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
	#print('nav', entity.nav)
	#print(entity.patrol_positions)
	entity.nav.target_position = entity.patrol_positions[current_point]


func exit() -> void:
	print("Exiting Patrol State")

func update(delta: float) -> void:
	if entity.patrol_positions.is_empty():
		return

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
		wait_timer += delta
		if wait_timer >= WAIT_TIME:
			waiting = false
			wait_timer = 0.0
			current_point = (current_point + 1) % entity.patrol_positions.size()
			entity.nav.target_position = entity.patrol_positions[current_point]
		return

	if entity.nav.is_navigation_finished():
		waiting = true
		entity.velocity = Vector2.ZERO
		return

	var next = entity.nav.get_next_path_position()
	var direction = (next - entity.global_position).normalized()
	entity.velocity = direction * entity.speed
	entity.vision.target_position = direction * entity.ray_length
	entity.move_and_slide()
