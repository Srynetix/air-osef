extends RigidBody2D
class_name Puck

signal effect_added(effect: PowerupEffect)
signal effect_removed(effect: PowerupEffect)

@onready var collision_shape := $CollisionShape2D as CollisionShape2D
@onready var _hit_sfx := $HitSFX as AudioStreamPlayer2D

var max_velocity := 1500.0
var game_limit_offset := 1000.0
var in_goal := false

var _last_hitter: Paddle
var _powerup_processor: PowerupProcessor

func _ready() -> void:
    _powerup_processor = PowerupProcessor.new()
    _powerup_processor.effect_added.connect(func(effect): emit_signal(effect_added.get_name(), effect))
    _powerup_processor.effect_removed.connect(func(effect): emit_signal(effect_removed.get_name(), effect))

    body_shape_entered.connect(_on_hit)

func _on_hit(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
    if body is Paddle:
        _last_hitter = body

    _hit_sfx.play()

func _physics_process(delta: float) -> void:
    _powerup_processor.process(delta)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    var game_size = get_viewport_rect().size
    
    if !in_goal && (position.x < -game_limit_offset || position.x > game_size.x + game_limit_offset || position.y < -game_limit_offset || position.y > game_size.y + game_limit_offset):
        var state_transform = state.transform
        state_transform.origin.x = game_size.x / 2
        state_transform.origin.y = game_size.y / 2
        state.transform = state_transform
        state.linear_velocity = Vector2.ZERO

    state.linear_velocity = state.linear_velocity.limit_length(max_velocity)

func shield_push(source: Paddle, amount: Vector2) -> void:
    _last_hitter = source
    apply_central_impulse(amount)
    _hit_sfx.play()

func add_powerup(powerup: PowerupEffect) -> void:
    if powerup is SlowPowerupEffect:
        if _last_hitter:
            _last_hitter.add_powerup(powerup)
    else:
        _powerup_processor.add_powerup(powerup)