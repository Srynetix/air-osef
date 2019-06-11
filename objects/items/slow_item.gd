extends "res://objects/items/item.gd"

###########
# Slow item

#################
# Private methods

func _activate_item():
    target_mode = TargetMode.Other
    emit_signal("item_activated", "slow", self)