extends Control
class_name GameScreen

enum GoalDirection {
    Left,
    Right
}

enum PlayerNumber {
    P1,
    P2
}

const PowerupEffectType = PowerupFactory.PowerupEffectType

@onready var _shockwave_fx := $Shockwave as SxFxShockwave
@onready var _score_p1_label := $ScoreP1 as Label
@onready var _score_p2_label := $ScoreP2 as Label
@onready var _pucks_group := $Pucks as Node2D
@onready var _powerups_group := $Powerups as Node2D
@onready var _goal_sfx := $GoalSFX as AudioStreamPlayer
@onready var _left_paddle := %LeftPaddle as Paddle
@onready var _right_paddle := %RightPaddle as Paddle

var _powerup_spawner: PowerupSpawner

var _score_p1 := 0 : set = _set_p1_score
var _score_p2 := 0 : set = _set_p2_score

func _ready() -> void:
    var game_size := get_viewport_rect().size

    match GameData.game_mode:
        GameData.GameMode.PlayerVsPlayer:
            _left_paddle.paddle_input_type = Paddle.PaddleInputType.Player
            _right_paddle.paddle_input_type = Paddle.PaddleInputType.Player
        GameData.GameMode.PlayerVsAi:
            _left_paddle.paddle_input_type = Paddle.PaddleInputType.Player
            _right_paddle.paddle_input_type = Paddle.PaddleInputType.Ai
        GameData.GameMode.AiVsAi:
            _left_paddle.paddle_input_type = Paddle.PaddleInputType.Ai
            _right_paddle.paddle_input_type = Paddle.PaddleInputType.Ai

    _powerup_spawner = PowerupSpawner.new()
    _powerup_spawner.spawn_requested.connect(_spawn_powerup_item)
    add_child(_powerup_spawner)

    _build_screen_limits()
    _spawn_puck_delayed(game_size / 2)

func _build_screen_limits() -> void:
    var game_size := get_viewport_rect().size

    var width := 8
    var goal_size := 250

    # Top wall
    _build_screen_wall(Vector2(game_size.x / 2, 0), Vector2(game_size.x, width))
    # Bottom wall
    _build_screen_wall(Vector2(game_size.x / 2, game_size.y), Vector2(game_size.x, width))
    # Left wall
    _build_goal_wall(Vector2(0, game_size.y / 2), Vector2(width, game_size.y), Vector2(width, goal_size), GoalDirection.Left)
    # Right wall
    _build_goal_wall(Vector2(game_size.x, game_size.y / 2), Vector2(width, game_size.y), Vector2(width, goal_size), GoalDirection.Right)
    # Middle
    _build_middle_wall(Vector2(game_size.x / 2, game_size.y / 2), Vector2(width, game_size.y))

func _build_goal_wall(wall_position: Vector2, wall_size: Vector2, goal_size: Vector2, goal_direction: GoalDirection) -> void:
    var small_wall_size = Vector2(wall_size.x, wall_size.y - wall_size.y / 2 - goal_size.y / 2)
    _build_screen_wall(wall_position - Vector2(0, small_wall_size.y / 2 + goal_size.y / 2), small_wall_size)
    _build_screen_wall(wall_position + Vector2(0, small_wall_size.y / 2 + goal_size.y / 2), small_wall_size)
    _build_goal(wall_position, goal_size, goal_direction)

func _build_screen_wall(wall_position: Vector2, wall_size: Vector2) -> StaticBody2D:
    var wall := StaticBody2D.new()
    wall.name = "Wall"
    var wall_collision_shape := CollisionShape2D.new()
    var wall_shape := RectangleShape2D.new()
    wall_shape.size = wall_size
    wall_collision_shape.shape = wall_shape
    wall.add_child(wall_collision_shape)
    wall.position = wall_position
    add_child(wall)
    return wall

func _build_goal(goal_position: Vector2, goal_size: Vector2, goal_direction: GoalDirection) -> StaticBody2D:
    var goal := StaticBody2D.new()
    goal.name = "Goal"
    goal.set_collision_layer_value(GameData.PADDLE_PHYSICS_LAYER, false)
    goal.set_collision_layer_value(GameData.GOAL_PHYSICS_LAYER, true)
    var goal_collision_shape := CollisionShape2D.new()
    var goal_shape := RectangleShape2D.new()
    goal_shape.size = Vector2(goal_size.x, goal_size.y)
    goal_collision_shape.shape = goal_shape
    goal.add_child(goal_collision_shape)
    goal.position = goal_position
    add_child(goal)

    var goal_area := Area2D.new()
    goal_area.name = "Area"
    goal_area.monitoring = true
    goal_area.set_collision_layer_value(GameData.PUCK_PHYSICS_LAYER, true)
    goal_area.set_collision_mask_value(GameData.PUCK_PHYSICS_LAYER, true)
    var goal_area_collision_shape := CollisionShape2D.new()
    var goal_area_shape := RectangleShape2D.new()
    goal_area_shape.size = Vector2(goal_size.x, goal_size.y)
    goal_area_collision_shape.shape = goal_area_shape
    goal_area.add_child(goal_area_collision_shape)
    goal.add_child(goal_area)

    goal_area.body_entered.connect(_check_ball_in_goal.bind(goal_direction))

    if goal_direction == GoalDirection.Left:
        goal_area.position = Vector2(-goal_size.x * 6, 0)
    else:
        goal_area.position = Vector2(goal_size.x * 6, 0)

    return goal

func _build_middle_wall(wall_position: Vector2, wall_size: Vector2) -> StaticBody2D:
    var wall := _build_screen_wall(wall_position, wall_size)
    wall.set_collision_layer_value(GameData.PADDLE_PHYSICS_LAYER, false)
    wall.set_collision_layer_value(GameData.MIDDLE_LINE_PHYSICS_LAYER, true)
    return wall

func _spawn_powerup_item(powerup_type: PowerupEffectType, powerup_position: Vector2) -> void:
    var powerup_item := GameLoadCache.instantiate_scene("PowerupItem") as PowerupItem
    powerup_item.powerup_effect_type = powerup_type
    powerup_item.position = powerup_position
    _powerups_group.add_child(powerup_item)

func _spawn_puck(puck_position: Vector2) -> void:
    var puck := GameLoadCache.instantiate_scene("Puck") as Puck
    puck.position = puck_position
    _pucks_group.add_child(puck)

    puck.effect_added.connect(_on_puck_powerup_effect_added.bind(puck))
    puck.effect_added.connect(_on_puck_powerup_effect_removed.bind(puck))

func _remove_puck(puck: Puck) -> void:
    _pucks_group.remove_child(puck)
    puck.queue_free()

func _spawn_puck_delayed(puck_position: Vector2) -> void:
    await get_tree().create_timer(2).timeout
    _spawn_puck(puck_position)

    var params = SxFxShockwave.WaveBuilder.new()
    params.position = puck_position
    params.speed = 0.15
    params.target_force = 0.05
    params.target_thickness = 0.05
    params.initial_wave_size = 0.05
    params.target_wave_size = 0.15
    _shockwave_fx.show_animated_wave(params)

func _on_puck_powerup_effect_added(effect: PowerupEffect, puck: Puck) -> void:
    if effect is MultiballPowerupEffect:
        _spawn_puck(puck.position)
        _spawn_puck(puck.position)

func _on_puck_powerup_effect_removed(effect: PowerupEffect, puck: Puck) -> void:
    pass

func _check_ball_in_goal(area: PhysicsBody2D, goal_direction: GoalDirection) -> void:
    if area is Puck:
        area.in_goal = true
        call_deferred("_run_goal_scenario", area, goal_direction)

func _run_goal_scenario(puck: Puck, goal_direction: GoalDirection):
    var game_size := get_viewport_rect().size
    var params = SxFxShockwave.WaveBuilder.new()
    if goal_direction == GoalDirection.Left:
        params.position = Vector2(-game_size.x / 4, game_size.y / 2)
    else:
        params.position = Vector2(game_size.x + game_size.x / 4, game_size.y / 2)

    params.speed = 0.5
    params.target_force = 0.1
    params.target_thickness = 0.1
    params.target_wave_size = 2.0
    _shockwave_fx.show_animated_wave(params)

    match goal_direction:
        GoalDirection.Right:
            _score_p1 += 1
        GoalDirection.Left:
            _score_p2 += 1

    puck.collision_shape.disabled = true
    _goal_sfx.play()

    await get_tree().create_timer(1).timeout

    _remove_puck(puck)

    if _pucks_group.get_child_count() == 0:
        _spawn_puck_delayed(game_size / 2)

func _set_p1_score(score: int) -> void:
    _score_p1 = score
    _score_p1_label.text = str(_score_p1)

func _set_p2_score(score: int) -> void:
    _score_p2 = score
    _score_p2_label.text = str(_score_p2)
