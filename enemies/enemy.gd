extends CharacterBody2D
class_name Enemy

@export var speed: float = 100.0
# SOUND BODIES SHOULD BE ON A SEPARATE LAYER TO AVOID COLLISIONS WITH THE ENEMY (USE LAYER 3 FOR SOUND BODIES AND MASK 3 FOR THE AREA OF SOUND)
@onready var areaOfSound: Area2D = %AreaOfSound
@onready var areaOfChasing: Area2D = %AreaOfChasing
@onready var areaOfDanger: Area2D = %AreaOfDanger
@onready var sprite: Sprite2D = %Sprite
@onready var vision: RayCast2D = %Vision
var ray_length: float
@onready var nav: NavigationAgent2D = %NavigationAgent
@export var patrol_points: Array[Marker2D] = []
var state: State
var patrol_positions: Array[Vector2] = []
var sound_target: Vector2

@onready var states = {
	"patrol": Patrol.new(),
	"chase": Chase.new(),
	"investigate": Investigate.new(),
}

func _ready() -> void:
	assert (areaOfSound != null, "areaOfSound should be assigned in the editor")
	assert (areaOfChasing != null, "areaOfChasing should be assigned in the editor")
	assert (sprite != null, "sprite should be assigned in the editor")
	assert (vision != null, "vision should be assigned in the editor")
	assert (nav != null, "Navigation should be assigned in the editor")
	assert (areaOfDanger != null, "areaOfDanger should be assigned in the editor")
	ray_length = vision.target_position.length()
	GameEndEventBus.connect("player_caught", _on_player_caught)
	change_state("patrol")
	for point in patrol_points:
		patrol_positions.append(point.global_position) 

func _physics_process(delta: float) -> void:
	state.update(delta)

func change_state(new_state: String) -> void:
	if state != null: 
		state.exit()
	state = states[new_state]
	state.set_entity(self)
	state.enter()

func _on_player_caught() -> void:
	queue_free()
