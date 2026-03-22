class_name TitleScreen
extends Control

signal game_started


func _on_start_button_pressed() -> void:
	game_started.emit()
