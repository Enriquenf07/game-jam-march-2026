extends CharacterBody2D
class_name Player

enum MovingDirection {UP, DOWN, LEFT, RIGHT, NONE}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FRICTION = 2000.0
@export var ray_length: float = 50.0
@onready var ray_cast: RayCast2D = %RayCast2D
var is_still = false
var _is_slipping: bool = false
var _is_stunned: bool = false
var _current_direction: MovingDirection = MovingDirection.NONE
@export var _debug_direction_label: Label
@export var _player_visual: AnimatedSprite2D

func _process(_delta: float) -> void:
	if (_debug_direction_label.visible):
		_debug_direction_label.text = "Movement Direction: " + _direction_as_string(_current_direction)

func _direction_as_string(direction: MovingDirection) -> String:
	match direction:
		MovingDirection.UP:
			return "UP"
		MovingDirection.DOWN:
			return "DOWN"
		MovingDirection.LEFT:
			return "LEFT"
		MovingDirection.RIGHT:
			return "RIGHT"
		MovingDirection.NONE:
			return "NONE"
	return ""

func _physics_process(delta: float) -> void:
	if (is_still or _is_stunned): return
	var direction := Input.get_vector('left', 'right', 'up', 'down').normalized()
	if (_is_slipping):
		velocity = set_sliding_direction(_current_direction)
	elif (direction != Vector2.ZERO):
		ray_cast.target_position = direction * ray_length
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	_current_direction = determine_moving_direction(velocity)

func determine_moving_direction(input_direction: Vector2) -> MovingDirection:
	if (input_direction.x > 0.0 and not (_current_direction == MovingDirection.UP or _current_direction == MovingDirection.DOWN)):
		return MovingDirection.RIGHT
	elif (input_direction.x < 0.0 and not (_current_direction == MovingDirection.UP or _current_direction == MovingDirection.DOWN)):
		return MovingDirection.LEFT
	elif (input_direction.y > 0.0 and not (_current_direction == MovingDirection.RIGHT or _current_direction == MovingDirection.LEFT)):
		return MovingDirection.DOWN
	elif (input_direction.y < 0.0 and not (_current_direction == MovingDirection.RIGHT or _current_direction == MovingDirection.LEFT)):
		return MovingDirection.UP
	return MovingDirection.NONE

func set_sliding_direction(movingDirection: MovingDirection) -> Vector2:
	match  movingDirection:
		MovingDirection.UP:
			return Vector2.UP * SPEED
		MovingDirection.DOWN:
			return Vector2.DOWN * SPEED
		MovingDirection.LEFT:
			return Vector2.LEFT * SPEED
		MovingDirection.RIGHT:
			return Vector2.RIGHT * SPEED
	return Vector2.ZERO
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed('interact') and ray_cast.is_colliding()):
		var collider := ray_cast.get_collider()
		if(collider is InteractableObject):
			collider.on_interaction(self)
			
func set_is_still(flag: bool):
	is_still = flag

func handle_trap_activation(trap: TrapBase.TrapType) -> void:
	match trap:
		TrapBase.TrapType.FLOORBOARD:
			print("squeak")
		TrapBase.TrapType.BANANA:
			_is_slipping = true
			print("slipped on banana")
		TrapBase.TrapType.MARBLES:
			_is_stunned = true
			_is_slipping = false
			_player_visual.play("marble_trip")
			velocity = Vector2.ZERO
			print("slipped on marbles")
		TrapBase.TrapType.MOUSE_TRAP:
			_is_stunned = true
			_is_slipping = false
			_player_visual.play("mouse_trap_hurt")
			velocity = Vector2.ZERO
			print("yeowch!!!")
		TrapBase.TrapType.PUDDLE:
			print("slipped on puddle")


func _on_animated_sprite_2d_animation_finished() -> void:
	if (_player_visual.animation == "marble_trip" or _player_visual.animation == "mouse_trap_hurt"):
		_is_stunned = false
