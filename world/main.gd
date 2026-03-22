class_name Main
extends Node

var _starting_screen: TitleScreen
var _game: World
var _title_screen: PackedScene = preload("res://world/title_screen/title_screen.tscn")
var _game_scene: PackedScene = preload("res://world/world.tscn")

func _ready() -> void:
	_game = _game_scene.instantiate()
	_starting_screen = _title_screen.instantiate()
	_starting_screen.connect("game_started", _on_game_started)
	add_child(_starting_screen)

func _on_game_started():
	_game = _game_scene.instantiate()
	_game.results_ui.connect("game_exited", _on_game_exited)
	_starting_screen.disconnect("game_started", _on_game_started)
	_starting_screen.queue_free()
	add_child(_game)

func _on_game_exited():
	_starting_screen = _title_screen.instantiate()
	_starting_screen.connect("game_started", _on_game_started)
	_game.results_ui.disconnect("game_exited", _on_game_exited)
	_game.queue_free()
	add_child(_starting_screen)
