extends StaticBody2D
class_name Goal

signal score()

var player_owner: Paddle = null

func goal() -> void:
    emit_signal("score")
