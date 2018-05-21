extends Node

func _ready():
    $solo.connect("button_down", self, "start_solo_game")
    $multi.connect("button_down", self, "start_multi_game")

func start_solo_game():
    var arena = preload("res://screens/arena/arena.tscn")
    get_tree().change_scene_to(arena)

func start_multi_game():
    pass