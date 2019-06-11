extends RigidBody2D

######
# Puck

var last_player_hit = null

###################
# Lifecycle methods

func _ready():
    connect("body_entered", self, "_on_body_entered")
    
#################
# Event callbacks

func _on_body_entered(body):
    if body.is_in_group("goal"):
        body.goal()

        queue_free()
