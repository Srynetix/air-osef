extends PowerupEffect
class_name SlowPowerupEffect

const EFFECT_DELAY := 5.0
const SLOW_VELOCITY := 250.0

var paddle: Paddle
var _elapsed_time := 0.0

func on_ready() -> void:
    paddle._max_velocity = SLOW_VELOCITY
    paddle.sprite.modulate = Color.GREEN

func process_effect(delta: float) -> void:
    if _elapsed_time >= EFFECT_DELAY:
        _should_remove = true
    else:
        _elapsed_time += delta

func on_exit() -> void:
    paddle._max_velocity = paddle.base_max_velocity
    paddle.sprite.modulate = Color.WHITE