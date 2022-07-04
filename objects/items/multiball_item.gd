extends "res://objects/items/item.gd"

func _activate_item() -> void:
    emit_signal("item_activated", "multiball", self)