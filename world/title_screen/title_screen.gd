class_name TitleScreen
extends Control

signal game_started

@export var _start_button: Button

func _ready() -> void:
	_start_button.grab_focus()

func _on_start_button_pressed() -> void:
	game_started.emit()
