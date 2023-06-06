extends Control

const GameMode = GameData.GameMode

@onready var _player_vs_player_btn := %PlayerVsPlayer
@onready var _player_vs_ai_btn := %PlayerVsAi
@onready var _ai_vs_ai_btn := %AiVsAi

func _ready() -> void:
    _player_vs_player_btn.pressed.connect(_run_game.bind(GameMode.PlayerVsPlayer))
    _player_vs_ai_btn.pressed.connect(_run_game.bind(GameMode.PlayerVsAi))
    _ai_vs_ai_btn.pressed.connect(_run_game.bind(GameMode.AiVsAi))

func _run_game(mode: GameMode) -> void:
    GameData.game_mode = mode
    process_mode = Node.PROCESS_MODE_DISABLED
    GameSceneTransitioner.fade_to_cached_scene(GameLoadCache, "GameScreen")