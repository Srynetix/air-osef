extends Control

onready var score = $CanvasLayer/MarginContainer/score
onready var gameover = $CanvasLayer/MarginContainer/gameover
onready var timer = $CanvasLayer/MarginContainer/timer

func update_score(player1: int, player2: int) -> void:
    score.text = str(player1) + " - " + str(player2)

func update_time(time: int) -> void:
    var minutes = int(time / 60.0)
    var seconds = time % 60

    if minutes < 10:
        minutes = "0" + str(minutes)

    if seconds < 10:
        seconds = "0" + str(seconds)

    timer.text = str(minutes) + ":" + str(seconds)

func show_game_over(winner: String) -> void:
    gameover.text = winner
