extends "res://objects/paddle/paddle.gd"

const MOVE_THRESHOLD = 2

var mouse_mode = true
var mouse_pressed = false
var mouse_motion_relative = Vector2()
var mouse_position = Vector2()

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            mouse_pressed = true
        if event.button_index == BUTTON_LEFT and not event.pressed:
            mouse_pressed = false

    elif event is InputEventMouseMotion:
        mouse_motion_relative = event.relative

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
            var relative_length = mouse_motion_relative.length()
            if relative_length > MOVE_THRESHOLD:
                current_direction = mouse_motion_relative.normalized()
                current_move_speed = MOVE_SPEED * (relative_length / 2)
            else:
                current_move_speed = 0

        else:
            # Drag
            current_move_speed /= 1.15