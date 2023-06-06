extends PaddleInput
class_name PlayerPaddleInput

var _touch_idx := -1
var _input_position := Vector2.ZERO
var _paddle_radius := 0
var _use_shield := false

func on_ready() -> void:
    var texture_size = paddle.sprite.texture.get_size()
    _paddle_radius = texture_size.x / 2.0

    paddle._double_tap.doubletap.connect(_on_doubletap)

func on_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed && _touch_idx == -1:
            var diff := (paddle.position - event.position as Vector2).length()
            if diff < _paddle_radius:
                _input_position = event.position
                _touch_idx = event.index

        if !event.pressed && event.index == _touch_idx:
            _touch_idx = -1
            _input_position = Vector2.ZERO

    if event is InputEventScreenDrag:
        if event.index == _touch_idx:
            _input_position = event.position

func _on_doubletap(_index: int) -> void:
    _use_shield = true

func get_movement() -> Vector2:
    return _input_position

func use_shield() -> bool:
    if _use_shield:
        _use_shield = false
        return true
    else:
        return false
