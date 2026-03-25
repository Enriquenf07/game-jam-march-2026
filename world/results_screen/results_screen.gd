class_name ResultsScreen
extends CanvasLayer

signal game_restarted
signal game_exited

@export var _win_screen: Control
@export var _replay_button: Button
@export var _score_text: Label
@export var _lose_screen: Control
@export var _try_again_button: Button

func show_win_screen(total_score: int):
	_win_screen.show()
	_replay_button.grab_focus()
	_score_text.text = "Total Stolen:\n$" + str(total_score)

func _on_exit_button_pressed() -> void:
	game_exited.emit()

func show_lose_screen():
	_lose_screen.show()
	_try_again_button.grab_focus()

func _on_play_again_button_pressed() -> void:
	game_restarted.emit()
