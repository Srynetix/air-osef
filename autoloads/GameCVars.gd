extends SxCVars

class _Vars:
    extends Object

    var game_zoom := 1.0
    var game_goal_limit := 5

func _init() -> void:
    _vars = _Vars.new()
    SxDebugConsole.bind_cvars(self)