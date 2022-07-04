extends Node2D

const MAX_SCORE = 4
const TIMER_LIMIT = 60 # seconds
const SPAWN_LIMIT_MARGIN = 25

onready var puck_scene = preload("res://objects/puck/puck.tscn")

onready var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/width")
onready var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/height")

var current_score_p1 = 0
var current_score_p2 = 0
var current_time = 0

var is_game_over = false

var AVAILABLE_ITEMS = [
    preload("res://objects/items/slow_item.tscn"),
    preload("res://objects/items/multiball_item.tscn")
]

func _ready() -> void:
    randomize()

    var player1 = $player
    var player2 = $ai

    $board/top_goal.player_owner = player2
    $board/bottom_goal.player_owner = player1

    # Connections
    $board/top_goal.connect("score", self, "_on_top_goal_score")
    $board/bottom_goal.connect("score", self, "_on_bottom_goal_score")

    $respawn_timer.connect("timeout", self, "_on_respawn_timer_timeout")
    $respawn_timer.start()

    $game_timer.connect("timeout", self, "_on_game_timer_timeout")
    $game_timer.start()

    $item_spawn_timer.connect("timeout", self, "_on_item_spawn_timer_timeout")
    $item_spawn_timer.start()

    $game_over_timer.connect("timeout", self, "_on_game_over_timer_timeout")

func _process(_delta: float) -> void:
    if Input.is_key_pressed(KEY_SPACE):
        spawn_puck(Vector2(rand_range(SPAWN_LIMIT_MARGIN, SCREEN_WIDTH - SPAWN_LIMIT_MARGIN), rand_range(100, SCREEN_HEIGHT - 100)))

func spawn_puck(puck_position: Vector2) -> void:
    var puck_instance = puck_scene.instance()
    puck_instance.position = puck_position

    $pucks.add_child(puck_instance)

func spawn_item(item_position: Vector2) -> void:
    var item_instance = AVAILABLE_ITEMS[rand_range(0, AVAILABLE_ITEMS.size())].instance()
    item_instance.position = item_position
    item_instance.connect("item_activated", self, "_on_item_activation")

    $items.add_child(item_instance)

func show_game_over() -> void:
    if is_game_over:
        return

    if current_score_p1 > current_score_p2:
        $ui.show_game_over("P1")
    elif current_score_p1 < current_score_p2:
        $ui.show_game_over("P2")
    else:
        $ui.show_game_over("DRAW")

    # Delete pucks
    for puck in $pucks.get_children():
        puck.queue_free()

    $game_over_timer.start()
    is_game_over = true
    
func _get_item_target(item: Item) -> Paddle:
    if item.target_mode == item.TargetMode.Self:
        return item.player

    if item.player == $player:
        return $ai as Paddle

    return $player as Paddle
    
func _update_scores() -> void:
    $ui.update_score(current_score_p1, current_score_p2)

    if current_score_p1 == MAX_SCORE or current_score_p2 == MAX_SCORE:
        show_game_over()
    else:
        $respawn_timer.start()
    
func _on_top_goal_score() -> void:
    if is_game_over:
        return

    current_score_p1 += 1
    _update_scores()

func _on_bottom_goal_score() -> void:
    if is_game_over:
        return

    current_score_p2 += 1
    _update_scores()

func _on_respawn_timer_timeout() -> void:
    if is_game_over:
        return

    spawn_puck(Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2))

func _on_game_timer_timeout() -> void:
    if is_game_over:
        return

    current_time += 1
    $ui.update_time(current_time)

    if current_time == TIMER_LIMIT:
        show_game_over()

func _on_item_spawn_timer_timeout() -> void:
    if $items.get_child_count() == 0:
        spawn_item(
            Vector2(
                rand_range(SPAWN_LIMIT_MARGIN, SCREEN_WIDTH - SPAWN_LIMIT_MARGIN),
                rand_range(SPAWN_LIMIT_MARGIN, SCREEN_HEIGHT - SPAWN_LIMIT_MARGIN)
            )
        )

func _on_item_activation(type: String, item: Item) -> void:
    if type == "slow":
        var target = _get_item_target(item)
        target.set_status("slow")

    elif type == "multiball":
        spawn_puck(item.position)

func _on_game_over_timer_timeout() -> void:
    get_tree().change_scene("res://screens/main_menu/main_menu.tscn")