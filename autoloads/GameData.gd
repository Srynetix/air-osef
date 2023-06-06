extends SxGameData

enum GameMode {
    PlayerVsPlayer,
    PlayerVsAi,
    AiVsAi
}

const PADDLE_PHYSICS_LAYER = 1
const PUCK_PHYSICS_LAYER = 2
const GOAL_PHYSICS_LAYER = 3
const MIDDLE_LINE_PHYSICS_LAYER = 4

var game_mode: GameMode : set = _set_game_mode, get = _get_game_mode

func _set_game_mode(mode: GameMode) -> void:
    game_mode = mode

func _get_game_mode() -> GameMode:
    return game_mode