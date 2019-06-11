extends StaticBody2D

######
# Goal

signal score

var player_owner = null

################
# Public methods

func goal():
    emit_signal("score")
