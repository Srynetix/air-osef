extends RigidBody2D

var last_player_hit: Paddle = null

func _ready() -> void:
    connect("body_entered", self, "_on_body_entered")
    
func _on_body_entered(body: PhysicsBody2D) -> void:
    if body.is_in_group("goal"):
        body.goal()

        queue_free()
