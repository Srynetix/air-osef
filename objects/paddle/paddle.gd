extends KinematicBody2D
class_name Paddle

const RUSH_SPEED_COEFF := 3.0
const MOVE_SPEED := 100.0
const THROW_SPEED := 150.0
const SLOW_SPEED_COEFF := 0.5

var _current_status := "none"
var _current_direction := Vector2()
var _current_move_speed := MOVE_SPEED

onready var _status_timer: Timer = $status_timer
onready var _sprite: Sprite = $sprite

func _ready() -> void:
    _status_timer.connect("timeout", self, "_on_status_timer_timeout")

func _physics_process(_delta: float) -> void:
    _handle_movement()
    _apply_movement()
    _handle_collisions()
    
func set_status(status: String) -> void:
    if _current_status == "none":
        if status == "slow":
            _sprite.modulate = Color(0.5, 0.5, 0, 1)
            _status_timer.wait_time = 3
            _status_timer.start()

        _current_status = status

func _reset_status() -> void:
    _sprite.modulate = Color(1, 1, 1, 1)
    _current_status = "none"
    
func _apply_movement() -> void:
    var speed = _current_direction * _current_move_speed
    if _current_status == "slow":
        speed *= SLOW_SPEED_COEFF

    move_and_slide(speed)

func _handle_collisions() -> void:
    for idx in range(get_slide_count()):
        var collision = get_slide_collision(idx)
        var collider = collision.collider
        if collider.is_in_group("puck"):
            collider.last_player_hit = self
            collider.apply_impulse(Vector2(), collision.normal * -THROW_SPEED)
            
func _handle_movement() -> void:
    pass
    
func _on_status_timer_timeout() -> void:
    _reset_status()