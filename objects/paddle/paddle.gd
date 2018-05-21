extends KinematicBody2D

var RUSH_SPEED_COEFF = 3.0
var MOVE_SPEED = 100.0
var THROW_SPEED = 150.0
var SLOW_SPEED_COEFF = 0.5

var current_status = "none"
var current_direction = Vector2()
var current_move_speed = MOVE_SPEED

func _ready():
    $status_timer.connect("timeout", self, "_on_status_timer_timeout")

func _physics_process(delta):
    _handle_movement()
    _apply_movement()
    _handle_collisions()

func _apply_movement():
    var speed = current_direction * current_move_speed
    if current_status == "slow":
        speed *= SLOW_SPEED_COEFF

    move_and_slide(speed)

func _handle_collisions():
    for idx in range(get_slide_count()):
        var collision = get_slide_collision(idx)
        var collider = collision.collider
        if collider.is_in_group("puck"):
            collider.last_player_hit = self
            collider.apply_impulse(Vector2(), collision.normal * -THROW_SPEED)

func set_status(status):
    if current_status == "none":
        if status == "slow":
            $sprite.modulate = Color(0.5, 0.5, 0, 1)
            $status_timer.wait_time = 3
            $status_timer.start()

        current_status = status

func reset_status():
    $sprite.modulate = Color(1, 1, 1, 1)
    current_status = "none"

func _on_status_timer_timeout():
    reset_status()