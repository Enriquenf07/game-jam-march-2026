class_name ResultsScreen
extends CanvasLayer

@export var _win_screen: Control
@export var _score_text: Label
@export var _lose_screen: Control

func show_win_screen(total_score: int):
	_win_screen.show()
	_score_text.text = "Total Stolen: $" + str(total_score)

func _on_exit_button_pressed() -> void:
	print("Return to Title Screen")

func show_lose_screen():
	_lose_screen.show()

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
