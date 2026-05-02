extends MeshInstance3D

var base_position: Vector3
var base_scale: Vector3

func _ready():
    base_position = position
    base_scale = scale

func _physics_process(_delta):
    var trail := mesh as TubeTrailMesh
    var section_count: float = trail.sections
    var section_len: float = trail.section_length

    # Total unscaled mesh length
    var base_size := section_count * section_len

    # How much the scaled length differs from the base scaled length
    var current_scaled_size := base_size * scale.y
    var base_scaled_size    := base_size * base_scale.y
    var delta_size          := current_scaled_size - base_scaled_size

    # Offset by half the delta so one end stays fixed
    # Use basis.y normalized to get the pure direction without scale baked in
    var local_up := transform.basis.y.normalized()
    position = base_position + local_up * (-delta_size * 0.5)
