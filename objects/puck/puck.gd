extends RigidBody2D

var last_player_hit = null

func _ready():
    connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
    if body.is_in_group("goal"):
        body.goal()

        queue_free()
