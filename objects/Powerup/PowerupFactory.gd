extends Object
class_name PowerupFactory

enum PowerupEffectType {
    Multiball,
    Slow
}

static func new_from_type(effect_type: PowerupEffectType) -> PowerupEffect:
    match effect_type:
        PowerupEffectType.Multiball:
            return MultiballPowerupEffect.new()
        PowerupEffectType.Slow:
            return SlowPowerupEffect.new()

    push_error("unknown effect")
    return null