extends Node3D

const MAX_SPEED = 60.0
const MAX_ROTATION_SPEED = 240.0
const SLOW_SPEED = 20.0
const MAX_TILT = 40.0
const TILT_SPEED = 700.0
const ACCELERATION = 15.0
const DECELERATION = 45.0
const ROTATION_ACCELERATION = MAX_ROTATION_SPEED*4
const ROTATION_DECELERATION = MAX_ROTATION_SPEED*4
const CAMERA_LAG_SPEED = 12.0
const CAMERA_APPROACH_SPEED = 150.0
const MAX_CAMERA_DISTANCE = 5.0
const MIN_CAMERA_DISTANCE = 4.0

var speed: float = 0.0
var rotation_speed: float = 0.0
var tilt: float = 0.0
var camera_rotation: float = 0.0
var camera_distance: float = MAX_CAMERA_DISTANCE

func _physics_process(delta: float) -> void:
    if Input.is_action_pressed("player_move_left"):
        rotation_speed = move_toward(rotation_speed, deg_to_rad(-MAX_ROTATION_SPEED), deg_to_rad(ROTATION_ACCELERATION) * delta)
        tilt = lerp(tilt, deg_to_rad(MAX_TILT), 1.0 - exp(deg_to_rad(-TILT_SPEED) * delta))
    elif Input.is_action_pressed("player_move_right"):
        rotation_speed = move_toward(rotation_speed, deg_to_rad(MAX_ROTATION_SPEED), deg_to_rad(ROTATION_ACCELERATION) * delta)
        tilt = lerp(tilt, deg_to_rad(-MAX_TILT), 1.0 - exp(deg_to_rad(-TILT_SPEED) * delta))
    else:
        rotation_speed = move_toward(rotation_speed, 0.0, deg_to_rad(ROTATION_DECELERATION) * delta)
        tilt = lerp(tilt, 0.0, 1.0 - exp(deg_to_rad(-TILT_SPEED) * delta))
    
    if Input.is_action_pressed("player_brake"):
        speed = move_toward(speed, SLOW_SPEED, DECELERATION * delta)
        camera_distance = lerp(camera_distance, MIN_CAMERA_DISTANCE, 1.0 - exp(deg_to_rad(-CAMERA_APPROACH_SPEED) * delta))
    else:
        speed = move_toward(speed, MAX_SPEED, ACCELERATION * delta)
        camera_distance = lerp(camera_distance, MAX_CAMERA_DISTANCE, 1.0 - exp(deg_to_rad(-CAMERA_APPROACH_SPEED) * delta))
        
    var target_rotation = rotation.z

    camera_rotation = lerp_angle(
        camera_rotation,
        target_rotation,
        1.0 - exp(-CAMERA_LAG_SPEED * delta)
    )

    %Camera.rotation.z = camera_rotation - rotation.z
    %PathFollow.progress += speed * delta
    %Camera.position.z = camera_distance
    rotate_z(rotation_speed * delta)
    %Player.rotation.z = tilt
