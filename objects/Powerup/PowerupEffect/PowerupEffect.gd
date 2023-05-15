extends Object
class_name PowerupEffect

var _should_remove := false

func on_ready() -> void:
    pass

func on_exit() -> void:
    pass

func process_effect(_delta: float) -> void:
    pass

func is_active() -> bool:
    return !_should_remove