extends Area2D
class_name PowerupItem

const PowerupEffectType = PowerupFactory.PowerupEffectType

var style_configuration := {
    PowerupEffectType.Multiball: {
        "color": Color.PURPLE,
        "texture": preload("res://objects/Powerup/PowerupEffect/MultiballPowerupEffect.png")
    },
    PowerupEffectType.Slow: {
        "color": Color.YELLOW,
        "texture": preload("res://objects/Powerup/PowerupEffect/SlowPowerupEffect.png")
    }
}

@export var powerup_effect_type := PowerupEffectType.Multiball : set = _set_powerup_effect_type

@onready var _sprite := $Sprite as Sprite2D
@onready var _particles := $CPUParticles2D as CPUParticles2D
@onready var _initial_scale := _sprite.scale

var _tween: Tween
var _consumed := false

func _ready() -> void:
    _set_powerup_effect_type(powerup_effect_type)

    body_entered.connect(_on_body_entered)
    _setup_animation()

func _on_body_entered(body: PhysicsBody2D) -> void:
    if body is Puck:
        call_deferred("_consume", body)

func _set_powerup_effect_type(value: PowerupEffectType) -> void:
    powerup_effect_type = value

    if !is_inside_tree():
        return

    _sprite.texture = style_configuration[powerup_effect_type]["texture"]
    _sprite.modulate = style_configuration[powerup_effect_type]["color"]
    _particles.modulate = style_configuration[powerup_effect_type]["color"]

func _consume(puck: Puck) -> void:
    if _consumed:
        return

    _consumed = true
    puck.add_powerup(PowerupFactory.new_from_type(powerup_effect_type))

    await _play_explode_animation()

    queue_free()

func _setup_animation() -> void:
    _tween = create_tween()
    _tween.tween_property(_sprite, "position", Vector2(0, -10), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).from(Vector2(0, 0))
    _tween.parallel().tween_property(_particles, "position", Vector2(0, -10), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).as_relative()
    _tween.tween_property(_sprite, "position", Vector2(0, 0), 0.5)
    _tween.parallel().tween_property(_particles, "position", Vector2(0, 10), 0.5).as_relative()
    _tween.tween_property(_sprite, "scale", Vector2(-_initial_scale.x, _initial_scale.y), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).from(_initial_scale)
    _tween.tween_property(_sprite, "scale", Vector2(_initial_scale.x, _initial_scale.y), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
    _tween.set_loops()

func _play_explode_animation() -> void:
    _tween.stop()
    _tween.kill()

    _tween = create_tween()
    _tween.tween_property(_sprite, "scale", _initial_scale * 10, 1.0).from(_initial_scale)
    _tween.parallel().tween_property(_sprite, "modulate", SxColor.with_alpha_f(_sprite.modulate, 0.0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
    _tween.parallel().tween_property(_particles, "modulate", SxColor.with_alpha_f(_particles.modulate, 0.0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
    await _tween.finished