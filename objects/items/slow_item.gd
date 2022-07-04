extends "res://objects/items/item.gd"

func _activate_item() -> void:
    target_mode = TargetMode.Other
    emit_signal("item_activated", "slow", self)