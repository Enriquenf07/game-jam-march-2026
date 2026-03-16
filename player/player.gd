extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FRICTION = 2000.0
@export var ray_length: float = 50.0
@onready var ray_cast: RayCast2D = %RayCast2D
var is_still = false
var is_running = false
var inventory: Inventory

func get_speed():
	return SPEED if !is_running else SPEED * 1.5

func _physics_process(delta: float) -> void:
	if(is_still): return
	var direction := Input.get_vector('left', 'right', 'up', 'down').normalized()
	if direction != Vector2.ZERO:
		ray_cast.target_position = direction * ray_length
		velocity = direction * get_speed()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("run")):
		is_running = true
		return
	if(event.is_action_released("run")):
		is_running = false
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
			print("slipped on banana")
		TrapBase.TrapType.MARBLES:
			print("slipped on marbles")
		TrapBase.TrapType.MOUSE_TRAP:
			print("yeowch!!!")
		TrapBase.TrapType.PUDDLE:
			print("slipped on puddle")
