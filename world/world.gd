extends Node2D
class_name World

@export var lerp_speed: float = 5.
@export var hud: Hud
@export var camera: Camera2D
@export var canvaModulate: CanvasModulate
@export var results_ui: ResultsScreen
@export var player: Player

func _ready() -> void:
	if(canvaModulate == null):
		assert(canvaModulate != null, 'The world doesn’t have a canvas modulate.')
	canvaModulate.color = Color.BLACK
	#hud.police_timer.start_timer()
	hud.police_timer.connect("police_arrived", _on_player_caught)
	GameEndEventBus.connect("player_escaped", _on_player_escaped)
	GameEndEventBus.connect("player_caught", _on_player_caught)

func _physics_process(delta: float) -> void:
	if(player == null):
		return
	var target_pos = player.global_position
	camera.global_position = camera.global_position.lerp(target_pos, lerp_speed * delta)

func _on_player_caught():
	hud.police_timer.stop_timer()
	player.stop_player()
	results_ui.show_lose_screen()

func _on_player_escaped():
	hud.police_timer.stop_timer()
	player.stop_player()
	results_ui.show_win_screen(hud._money)
