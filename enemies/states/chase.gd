extends State
class_name Chase

func enter() -> void:
    print("Entering Chase State")

func exit() -> void:
    print("Exiting Chase State")

func update(delta: float) -> void:
    var player = entity.areaOfChasing.get_collider()
    if player and player.is_in_group("Player"):
        var direction = (player.global_position - entity.global_position).normalized()
        entity.velocity = direction * entity.speed
        entity.vision.target_position = direction * entity.ray_length
        entity.move_and_slide()
    else:
        entity.change_state("patrol")  