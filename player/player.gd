extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FRICTION = 2000.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector('left', 'right', 'up', 'down')
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()

func handle_trap_activation(trap: TrapBase.TrapType) -> void:
	match trap:
		TrapBase.TrapType.FLOORBOARD:
			print("squeak")
		TrapBase.TrapType.BANANA:
			print("slipped on banana")
		TrapBase.TrapType.MARBLES:
			print("slipped on marbles")
		TrapBase.TrapType.MOUSE_TRAP:
			print("yeowch!!!")
		TrapBase.TrapType.PUDDLE:
			print("slipped on puddle")
