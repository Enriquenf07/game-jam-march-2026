class_name DisarmUI
extends Control

@export var _progress_animator: AnimationPlayer
var is_disarming: bool = false

func _ready() -> void:
	hide()

func set_progress_speed(time_to_disarm: float):
	_progress_animator.speed_scale = 1.0 / time_to_disarm

func start_disarming():
	is_disarming = true
	show()
	_progress_animator.play("disarming")

func stop_disarming():
	is_disarming = false
	hide()
	_progress_animator.stop()
