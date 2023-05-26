extends Node2D
class_name PowerupSpawner

const PowerupEffectType = PowerupFactory.PowerupEffectType

const POWERUP_SPAWN_DELAY := 5.0

signal spawn_requested(powerup_type: PowerupEffectType, powerup_position: Vector2)

var _timer: Timer

func _ready():
    _timer = Timer.new()
    _timer.wait_time = POWERUP_SPAWN_DELAY
    _timer.autostart = true
    _timer.timeout.connect(_spawn_random_powerup)
    add_child(_timer)

func _spawn_random_powerup() -> void:
    var game_size := get_viewport_rect().size
    var offset := 64

    var random_position = Vector2(
        randf_range(offset, game_size.x - offset),
        randf_range(offset, game_size.y - offset),
    )

    var powerup_type = PowerupEffectType.Multiball
    var rand_num = randi_range(0, 4)
    if rand_num < 3:
        powerup_type = PowerupEffectType.Multiball
    else:
        powerup_type = PowerupEffectType.Slow

    emit_signal(spawn_requested.get_name(), powerup_type, random_position)