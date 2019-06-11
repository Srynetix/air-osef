extends "res://objects/items/item.gd"

################
# Multiball item

#################
# Private methods

func _activate_item():
    emit_signal("item_activated", "multiball", self)