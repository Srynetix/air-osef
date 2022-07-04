extends "res://objects/paddle/paddle.gd"

const AI_MOVE_SPEED := MOVE_SPEED * 3

func _handle_movement() -> void:
    # Get pucks
    var min_distance = 99999
    var min_puck = null

    var ai_goal = get_node("/root/arena/board/top_goal")
    var pucks = get_node("/root/arena/pucks")

    for puck in pucks.get_children():
        var distance = puck.position.distance_to(ai_goal.position)
        if distance < min_distance:
            min_distance = distance
            min_puck = puck

    if min_puck:
        _current_direction = (min_puck.position - position).normalized()
        _current_move_speed = AI_MOVE_SPEED