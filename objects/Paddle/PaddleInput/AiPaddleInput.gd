extends PaddleInput
class_name AiPaddleInput

const GoalDirection = GameScreen.GoalDirection

var direction := GoalDirection.Left
var game_zone := Rect2()

var _timer: Timer
var _freezed := false

func on_ready() -> void:
    var game_size := paddle.get_viewport_rect().size

    if paddle.position.x > game_size.x / 2:
        game_zone = Rect2(game_size.x / 2, 0, game_size.x / 2, game_size.y)
        direction = GoalDirection.Right
    else:
        game_zone = Rect2(0, 0, game_size.x / 2, game_size.y)

    _timer = Timer.new()
    _timer.wait_time = 0.2
    _timer.autostart = false
    _timer.one_shot = true
    _timer.timeout.connect(_freeze_timeout)
    paddle.add_child(_timer)

func on_exit() -> void:
    paddle.remove_child(_timer)
    _timer.queue_free()

func _freeze_timeout() -> void:
    _timer.stop()
    _freezed = false

func _detect_nearest_puck(origin: Vector2) -> Puck:
    var nearest_puck: Puck = null
    var nearest_distance: float = INF
    for node in paddle.get_tree().get_nodes_in_group("puck"):
        var puck = node as Puck
        var dist = origin.distance_squared_to(puck.position)
        if dist < nearest_distance:
            nearest_distance = dist
            nearest_puck = puck
    return nearest_puck

func get_movement() -> Vector2:
    if !_freezed:
        _freezed = true
        _timer.start()

        var puck := _detect_nearest_puck(paddle.position)
        if puck && game_zone.has_point(puck.position):
            return puck.position
        return _defense_position()

    return Vector2.ZERO

func _defense_position() -> Vector2:
    var game_size := paddle.get_viewport_rect().size
    var x_offset := 128

    var defense_position := Vector2()
    if direction == GoalDirection.Left:
        defense_position = Vector2(x_offset, game_size.y / 2)
    else:
        defense_position = Vector2(game_size.x - x_offset, game_size.y / 2)

    var puck := _detect_nearest_puck(defense_position)
    if puck:
        defense_position.y = puck.position.y

    return defense_position

func use_shield() -> bool:
    return randf_range(0, 1) > 0.95
