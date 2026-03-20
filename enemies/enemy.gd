extends CharacterBody2D
class_name Enemy

@export var speed: float = 100.0
@onready var areaOfSound: Area2D = %AreaOfSound
@onready var areaOfChasing: Area2D = %AreaOfChasing
@onready var sprite: Sprite2D = %Sprite
@export var vision: RayCast2D = %Vision
@export var ray_length: float = 50.0
var state: State

@onready var states = {
    "patrol": Patrol.new(),
    "chase": Chase.new(),
}

func _ready() -> void:
    assert areaOfSound != null, "areaOfSound should be assigned in the editor"
    assert areaOfChasing != null, "areaOfChasing should be assigned in the editor"
    assert sprite != null, "sprite should be assigned in the editor"
    assert vision != null, "vision should be assigned in the editor"
    change_state("patrol")

func _physics_process(delta: float) -> void:
    state.update(delta)

func change_state(new_state: String) -> void:
    state.exit()
    state = states[new_state]
    state.set_entity(self)
    state.enter()

