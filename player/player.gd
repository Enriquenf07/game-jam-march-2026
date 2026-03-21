extends CharacterBody2D
class_name Player

enum MovingDirection {UP, DOWN, LEFT, RIGHT, NONE}

const SPEED = 300.0
const SLIPPING_SPEED: float = 375.0
const JUMP_VELOCITY = -400.0
const FRICTION = 2000.0
const DOWN_RAY_LENGTH_EXTENSION: float = 46.0
@export var ray_length: float = 50.0
@onready var ray_cast: RayCast2D = %RayCast2D
var _is_slipping: bool = false
var _is_stunned: bool = false
var _current_direction: MovingDirection = MovingDirection.NONE
@export var _debug_direction_label: Label
@export var _player_visual: AnimatedSprite2D
var is_running = false
var inventory: Inventory
@export var _disarm_progress_bar: DisarmUI
var trap_to_disarm: TrapBase
var _direction_when_disarming: MovingDirection = MovingDirection.NONE
var _is_disarming = false
@export var _interaction_prompt: Label

func get_speed():
	return SPEED if !is_running else SPEED * 1.5

func _process(_delta: float) -> void:
	if (_debug_direction_label.visible):
		_debug_direction_label.text = "Movement Direction: " + _direction_as_string(_current_direction)
	_determine_interaction_prompt()

func _determine_interaction_prompt() -> void:
	if (_is_disarming or not ray_cast.is_colliding() or _is_slipping or _is_stunned):
		_interaction_prompt.hide()
		return
	var collider = ray_cast.get_collider()
	if (collider is not InteractableObject):
		return
	_display_interaction_prompt(collider)

func _display_interaction_prompt(interactable: InteractableObject):
	if (interactable.is_in_group("trap")):
		_interaction_prompt.text = "E - Disarm"
		_interaction_prompt.show()
	elif (interactable.is_in_group("loot")):
		_interaction_prompt.text = "E - Steal"
		_interaction_prompt.show()

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
	if (_is_stunned): return
	var direction := Input.get_vector('left', 'right', 'up', 'down').normalized()
	_check_disarm_cancelling(direction)
	if (_is_disarming): return
	if (_is_slipping):
		velocity = set_sliding_direction(_current_direction)
		move_and_slide()
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider() != null:
				_is_slipping = false
				velocity = Vector2.ZERO
				break
		velocity = set_sliding_direction(_current_direction)
	elif (direction != Vector2.ZERO):
		ray_cast.target_position = _set_ray_direction(direction)
		velocity = direction * get_speed()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	_current_direction = determine_moving_direction(velocity)
	_determine_movement_animation()

func _check_disarm_cancelling(input_direction: Vector2) -> void:
	var moving_direction = determine_moving_direction(input_direction)
	if (moving_direction == MovingDirection.NONE):
		return
	if (moving_direction != _direction_when_disarming):
		_is_disarming = false
		_disarm_progress_bar.stop_disarming()

func _set_ray_direction(input_direction: Vector2) -> Vector2:
	if (input_direction.x == 0.0 and input_direction.y > 0.0):
		return input_direction * (ray_length + DOWN_RAY_LENGTH_EXTENSION)
	return input_direction * ray_length

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
			return Vector2.UP * SLIPPING_SPEED
		MovingDirection.DOWN:
			return Vector2.DOWN * SLIPPING_SPEED
		MovingDirection.LEFT:
			return Vector2.LEFT * SLIPPING_SPEED
		MovingDirection.RIGHT:
			return Vector2.RIGHT * SLIPPING_SPEED
	return Vector2.ZERO

func _determine_movement_animation():
	if (_is_slipping or _is_stunned or _is_disarming):
		return
	if (velocity == Vector2.ZERO):
		_player_visual.play("idle")
		return
	elif (velocity.x < 0.0):
		_player_visual.flip_h = true
	elif (velocity.x > 0.0):
		_player_visual.flip_h = false
	_play_movement_animation()

func _play_movement_animation():
	if (is_running):
		_player_visual.play("run")
		return
	_player_visual.play("sneak")

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("run") and not _is_slipping):
		is_running = true
		return
	if(event.is_action_released("run")):
		is_running = false
	if(event.is_action_pressed('interact') and ray_cast.is_colliding()):
		var collider := ray_cast.get_collider()
		if(collider is InteractableObject):
			print("interacted")
			collider.on_interaction(self)

func set_is_disarming(flag: bool) -> void:
	_is_disarming = flag
	if (_is_disarming):
		_player_visual.play("disarming")
		velocity = Vector2.ZERO

func handle_trap_disarming() -> void:
	_direction_when_disarming = _current_direction
	_disarm_progress_bar.set_progress_speed(trap_to_disarm.time_to_disable)
	_disarm_progress_bar.start_disarming()

func _on_disarming_animatior_animation_finished(anim_name: StringName) -> void:
	if (anim_name != "disarming"):
		return
	trap_to_disarm.disarm()
	_disarm_progress_bar.stop_disarming()
	_is_disarming = false

func handle_trap_activation(trap: TrapBase.TrapType) -> void:
	match trap:
		TrapBase.TrapType.FLOORBOARD:
			print("squeak")
		TrapBase.TrapType.BANANA:
			_is_slipping = true
			is_running = false
			_player_visual.play("banana_slip")
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

func slip_on_puddle():
	_is_stunned = true
	_is_slipping = false
	_player_visual.play("puddle_slip")
	velocity = Vector2.ZERO

func _on_animated_sprite_2d_animation_finished() -> void:
	if (not _is_in_stunned_animation(_player_visual.animation)):
		return
	_is_stunned = false
	if (Input.is_action_pressed("run")):
		is_running = true

func _is_in_stunned_animation(player_animation: StringName) -> bool:
	return (player_animation == "marble_trip" or player_animation == "mouse_trap_hurt" or player_animation == "puddle_slip")
