extends Object
class_name PowerupProcessor

signal effect_added(effect: PowerupEffect)
signal effect_removed(effect: PowerupEffect)

var _effects := [] as Array[PowerupEffect]

func add_powerup(powerup: PowerupEffect) -> void:
    _effects.push_back(powerup)
    powerup.on_ready()
    emit_signal(effect_added.get_name(), powerup)

func remove_powerup(powerup: PowerupEffect) -> void:
    _effects.erase(powerup)
    powerup.on_exit()
    emit_signal(effect_removed.get_name(), powerup)

func process(delta: float) -> void:
    var effects_to_remove := [] as Array[PowerupEffect]
    for effect in _effects:
        effect.process_effect(delta)

        if !effect.is_active():
            effects_to_remove.push_back(effect)

    for effect in effects_to_remove:
        remove_powerup(effect)