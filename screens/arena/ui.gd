extends Control

####
# UI

onready var score = $CanvasLayer/MarginContainer/score
onready var gameover = $CanvasLayer/MarginContainer/gameover
onready var timer = $CanvasLayer/MarginContainer/timer

################
# Public methods

func update_score(player1, player2):
    score.text = str(player1) + " - " + str(player2)

func update_time(time):
    var minutes = time / 60
    var seconds = time % 60

    if minutes < 10:
        minutes = "0" + str(minutes)

    if seconds < 10:
        seconds = "0" + str(seconds)

    timer.text = str(minutes) + ":" + str(seconds)

func show_game_over(winner):
    gameover.text = winner