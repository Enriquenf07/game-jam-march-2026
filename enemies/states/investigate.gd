extends State
class_name Investigate

const ARRIVE_DISTANCE: float = 10.0
const WAIT_TIME: float = 3.0

var target: Vector2 = Vector2.ZERO
var wait_timer: float = 0.0
var arrived: bool = false

func enter() -> void:
	print("Entering Investigate State")
	target = entity.sound_target
	wait_timer = 0.0
	arrived = false

func exit() -> void:
	print("Exiting Investigate State")

func update(delta: float) -> void:
	if entity.vision.is_colliding():
		if entity.vision.get_collider().is_in_group("Player"):
			entity.change_state("chase")
			return

	if not arrived:
		if entity.nav.is_navigation_finished():
			arrived = true
			entity.velocity = Vector2.ZERO
			return
		var next = entity.nav.get_next_path_position()
		var direction = (next - entity.global_position).normalized()
		entity.velocity = direction * entity.speed
		entity.vision.target_position = direction * entity.ray_length
		entity.move_and_slide()
	else:
		wait_timer += delta
		if wait_timer >= WAIT_TIME:
			entity.change_state("patrol")
