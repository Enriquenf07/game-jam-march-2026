class_name GrabbableLoot
extends Node2D

@export var _loot_value: int = 100
@export var _loot_visual: Sprite2D
@export var _loot_collection_sound: AudioStreamPlayer
@export var _loot_value_text: Label
@export var _loot_value_animation: AnimationPlayer
@export var _loot_interaction_collision: CollisionShape2D

func _ready() -> void:
	_loot_value_text.text = "$" + str(_loot_value)
	_loot_collection_sound.pitch_scale = randf_range(0.95, 1.05)

func _on_interactable_object_interacted(_interacting_player: Player) -> void:
	_loot_visual.hide()
	_loot_collection_sound.play()
	_loot_value_text.show()
	_loot_value_animation.play("loot_value_float")
	_loot_interaction_collision.set_deferred("disabled", true)
	LootEventBus.emit_signal("loot_collected", _loot_value)


func _on_loot_value_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name != "loot_value_float"):
		return
	queue_free()
