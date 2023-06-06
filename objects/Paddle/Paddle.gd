extends RigidBody2D
class_name Paddle

enum PaddleInputType {
    Player,
    Ai
}

const base_max_velocity := 1500.0

@export var paddle_input_type := PaddleInputType.Player : set = _set_paddle_input_type
@onready var _shield_animation_player := $Shield/AnimationPlayer as AnimationPlayer
@onready var _shield_sfx := $Shield/ShieldSFX as AudioStreamPlayer2D
@onready var _double_tap := $SxDoubleTap as SxDoubleTap
@onready var sprite := $Sprite as Sprite2D

var _max_velocity := base_max_velocity
var _paddle_input: PaddleInput
var _shield_cooldown: Timer
var _powerup_processor: PowerupProcessor

func _ready() -> void:
    _set_paddle_input_type(paddle_input_type)

    _powerup_processor = PowerupProcessor.new()

    _shield_cooldown = Timer.new()
    _shield_cooldown.one_shot = true
    _shield_cooldown.wait_time = 1
    _shield_cooldown.autostart = false
    add_child(_shield_cooldown)

func _set_paddle_input_type(input_type: PaddleInputType) -> void:
    if !is_inside_tree():
        paddle_input_type = input_type
        return

    if _paddle_input:
        _paddle_input.on_exit()

    paddle_input_type = input_type
    match paddle_input_type:
        PaddleInputType.Player:
            _paddle_input = PlayerPaddleInput.new()
        PaddleInputType.Ai:
            _paddle_input = AiPaddleInput.new()

    _paddle_input.paddle = self
    _paddle_input.on_ready()

func _exit_tree():
    _paddle_input.on_exit()

func _physics_process(delta: float) -> void:
    _powerup_processor.process(delta)

    var sprite_size := sprite.texture.get_size() * sprite.scale
    _double_tap.target_rect = Rect2(sprite.global_position - sprite_size / 2, sprite_size)

    if _paddle_input.use_shield():
        _activate_shield()

func _input(event: InputEvent) -> void:
    _paddle_input.on_input(event)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    var game_size := get_viewport_rect().size
    var input_position := _paddle_input.get_movement()
    if input_position != Vector2.ZERO && Rect2(Vector2.ZERO, game_size).has_point(input_position):
        state.linear_velocity = (input_position - position) * 8.0

    state.linear_velocity = state.linear_velocity.limit_length(_max_velocity)

func _activate_shield() -> void:
    if _shield_cooldown.is_stopped():
        _shield_cooldown.start()

        var pucks := get_tree().get_nodes_in_group("puck")
        for node in pucks:
            var puck = node as Puck
            if puck.position.distance_to(position) < 256:
                puck.shield_push(self, (puck.position - position).normalized() * 500.0)

        _shield_sfx.play()
        _shield_animation_player.play("grow")

func add_powerup(powerup: PowerupEffect) -> void:
    if powerup is SlowPowerupEffect:
        powerup.paddle = self

    _powerup_processor.add_powerup(powerup)