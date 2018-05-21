extends StaticBody2D

signal score

var player_owner = null


func goal():
    emit_signal("score")
