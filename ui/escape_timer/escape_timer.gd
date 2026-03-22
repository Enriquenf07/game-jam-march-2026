class_name EscapeTimer
extends Control

signal police_arrived

@export var _time_left: Label
@export var _escape_clock: Timer
@export var _minutes_left: int = 0
@export var _seconds_left: int = 15

func _ready() -> void:
	hide()
	_update_clock_label()

func start_timer():
	show()
	_escape_clock.start()

func stop_timer():
	hide()
	_escape_clock.stop()

func _on_escape_clock_timeout() -> void:
	if (_seconds_left == 0):
		if (_minutes_left == 0):
			police_arrived.emit()
			_escape_clock.stop()
			return
		_minutes_left -= 1
		_seconds_left = 59
		_update_clock_label()
		return
	_seconds_left -= 1
	_update_clock_label()

func _update_clock_label():
	_time_left.text = "Police Arrive In: " + str(_minutes_left) + ":"
	if (_seconds_left < 10):
		_time_left.text += "0" + str(_seconds_left)
		return
	_time_left.text += str(_seconds_left)
