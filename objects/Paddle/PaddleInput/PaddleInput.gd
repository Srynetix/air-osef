extends Object
class_name PaddleInput

var paddle: Paddle

func on_ready() -> void:
    pass

func on_input(_event: InputEvent) -> void:
    pass

func on_exit() -> void:
    pass

func get_movement() -> Vector2:
    return Vector2()

func use_shield() -> bool:
    return false