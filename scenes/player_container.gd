extends Node3D

const MAX_SPEED = 240.0
const MAX_TILT = 15.0
const TILT_SPEED = 700.0
const ACCELERATION = MAX_SPEED*4
const DECELERATION = MAX_SPEED*4

var speed: float = 0.0
var tilt: float = 0.0

func _physics_process(delta: float) -> void:
    if Input.is_action_pressed("player_move_left"):
        speed = move_toward(speed, deg_to_rad(-MAX_SPEED), deg_to_rad(ACCELERATION) * delta)
        tilt = lerp(tilt, deg_to_rad(MAX_TILT), 1.0 - exp(deg_to_rad(-TILT_SPEED) * delta))
    elif Input.is_action_pressed("player_move_right"):
        speed = move_toward(speed, deg_to_rad(MAX_SPEED), deg_to_rad(ACCELERATION) * delta)
        tilt = lerp(tilt, deg_to_rad(-MAX_TILT), 1.0 - exp(deg_to_rad(-TILT_SPEED) * delta))
    else:
        speed = move_toward(speed, 0.0, deg_to_rad(DECELERATION) * delta)
        tilt = lerp(tilt, 0.0, 1.0 - exp(deg_to_rad(-TILT_SPEED) * delta))
    
    rotate_z(speed * delta)
    %Player.rotation.z = tilt
