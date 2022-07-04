extends Area2D
class_name Item

signal item_activated()

enum TargetMode {
    Self,
    Other
}

var target_mode: int = TargetMode.Self

var _item_used := false
var _player: Paddle

func _ready() -> void:
    connect("body_entered", self, "_on_body_entered")
    
func _activate_item() -> void:
    pass
    
func _on_body_entered(body: PhysicsBody2D) -> void:
    if body.is_in_group("puck") and !_item_used:
        _player = body.last_player_hit
        _activate_item()
        _item_used = true

        queue_free()
