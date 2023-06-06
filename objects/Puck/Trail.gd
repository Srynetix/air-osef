extends Line2D
class_name GameTrail

@export var length := 50

var _point = Vector2.ZERO

func _process(_delta: float) -> void:
    global_position = Vector2.ZERO
    global_rotation = 0

    _point = get_parent().global_position

    add_point(_point)
    while get_point_count() > length:
        remove_point(0)