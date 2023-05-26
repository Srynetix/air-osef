extends SxLoadCache

func load_resources() -> void:
    store_scene("BootScreen", "res://screens/BootScreen/BootScreen.tscn")
    store_scene("TitleScreen", "res://screens/TitleScreen/TitleScreen.tscn")
    store_scene("GameScreen", "res://screens/GameScreen/GameScreen.tscn")
    store_scene("Puck", "res://objects/Puck/Puck.tscn")
    store_scene("PowerupItem", "res://objects/Powerup/PowerupItem.tscn")
