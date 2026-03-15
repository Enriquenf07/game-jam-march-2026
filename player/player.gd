extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FRICTION = 2000.0
@export var ray_length: float = 50.0
@onready var ray_cast: RayCast2D = %RayCast2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector('left', 'right', 'up', 'down').normalized()
	if direction != Vector2.ZERO:
		ray_cast.target_position = direction * ray_length
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
