class_name BasicLoot
extends Area2D

@export var loot_value: int = 100
@export var loot_visual: Sprite2D
@export var loot_collision: CollisionShape2D
@export var loot_collection_sound: AudioStreamPlayer
@export var loot_value_text: Label
@export var loot_value_animation: AnimationPlayer

func _ready() -> void:
	loot_value_text.text = "$" + str(loot_value)

func _on_body_entered(body: Node2D) -> void:
	if (not body.is_in_group("player")):
		return
	loot_collection_sound.play()
	loot_value_text.show()
	loot_value_animation.play("loot_value_float")
	loot_collision.set_deferred("disabled", true)
	LootEventBus.emit_signal("loot_collected", loot_value)

func _on_loot_value_animation_player_animation_finished(anim_name: StringName) -> void:
	if (not anim_name == "loot_value_float"):
		return
	queue_free()
