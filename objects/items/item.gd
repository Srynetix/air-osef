extends Area2D

######
# Item

signal item_activated

enum TargetMode {
    Self,
    Other
}

var item_used = false
var player = null
var target_mode = TargetMode.Self

###################
# Lifecycle methods

func _ready():
    connect("body_entered", self, "_on_body_entered")
    
#################
# Private methods

func _activate_item():
    pass
    
#################
# Event callbacks

func _on_body_entered(body):
    if body.is_in_group("puck") and not item_used:
        player = body.last_player_hit
        _activate_item()
        item_used = true

        queue_free()
