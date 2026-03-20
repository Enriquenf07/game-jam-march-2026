extends State
class_name Patrol


func enter() -> void:
    print("Entering Patrol State")

func exit() -> void:
    print("Exiting Patrol State")

func update(delta: float) -> void:
    var direction = Vector2.ZERO
    if randf() < 0.5:
        direction.x = -1 
    else:
        direction.x = 1  
    entity.velocity = direction * entity.speed
    entity.vision.target_position = direction * entity.ray_length
    if(entity.vision.is_colliding()):
        var collider = entity.vision.get_collider()
        if collider.is_in_group("Player"):
            entity.change_state("chase")
    entity.move_and_slide()
