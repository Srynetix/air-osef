extends Control
class_name BootScreen


func _ready() -> void:
    GameSceneTransitioner.fade_to_cached_scene(GameLoadCache, "TitleScreen")