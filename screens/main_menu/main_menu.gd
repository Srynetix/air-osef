extends Node

onready var solo_btn = $margin/vbox/buttons/solo
onready var multi_btn = $margin/vbox/buttons/multi

func _ready():
    solo_btn.connect("button_down", self, "start_solo_game")
    multi_btn.connect("button_down", self, "start_multi_game")

func start_solo_game():
    var arena = preload("res://screens/arena/arena.tscn")
    get_tree().change_scene_to(arena)

func start_multi_game():
    pass