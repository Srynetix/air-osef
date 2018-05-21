extends "res://objects/paddle/paddle.gd"

const RUSH_THRESHOLD = 50

var mouse_mode = true
var mouse_pressed = false
var mouse_position = Vector2()

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            mouse_pressed = true
        if event.button_index == BUTTON_LEFT and not event.pressed:
            mouse_pressed = false

func _handle_movement():
    if not mouse_mode:
        var direction = Vector2()
        if Input.is_action_pressed("ui_left"):
            direction.x -= 1
        if Input.is_action_pressed("ui_right"):
            direction.x += 1
        if Input.is_action_pressed("ui_up"):
            direction.y -= 1
        if Input.is_action_pressed("ui_down"):
            direction.y += 1

        current_direction = direction

    else:
        if mouse_pressed:
            mouse_position = get_viewport().get_mouse_position()
            var distance = mouse_position.distance_to(position)

            if distance > 2:
                current_direction = (mouse_position - position).normalized()
                if distance > RUSH_THRESHOLD:
                    current_move_speed = MOVE_SPEED * 5
                else:
                    current_move_speed = MOVE_SPEED * 3
            else:
                current_move_speed = 0

        else:
            current_move_speed /= 1.15