extends SubViewportContainer

const ROTATION_SPEED := 360.0 / 4.0

func _physics_process(delta: float) -> void:
    %Model.rotate_y(deg_to_rad(-ROTATION_SPEED * delta))
