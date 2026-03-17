extends Node
class_name PlayerFactory
const PLAYER_SCENE: PackedScene = preload("res://player/player.tscn")

func create(pos: Vector2, parent: Node2D, inventory: Inventory):
	var player := PLAYER_SCENE.instantiate() as Player
	player.global_position = pos
	parent.add_child(player)
	player.inventory = inventory
	return player
