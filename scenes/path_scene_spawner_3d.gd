extends Node3D
class_name PathSceneSpawner3D

@export var path: Path3D
@export var scene: PackedScene
@export_range(0.001, 99999.0) var distance: float = 1.0
@export var offset: Vector3
@export var start_at_zero: bool

@export_group("Random", "random")
@export var random_enabled: bool
@export var random_randomize_distance: bool
@export_range(0.001, 99999.0) var random_min_distance: float
@export_range(0.001, 99999.0) var random_max_distance: float
@export var random_randomize_rotation: bool

func _ready() -> void:
    var curve: Curve3D = path.curve

    var d = randf_range(random_min_distance, random_max_distance) if random_enabled and random_randomize_distance else distance
    var current_offset = 0.0 if start_at_zero else d
    
    while current_offset < curve.get_baked_length():
        var rot = randf_range(0.0, 360.0)
        var t = curve.sample_baked_with_rotation(current_offset)
        var instance = scene.instantiate()
        var local_offset = offset
        t.origin += t.basis * local_offset
        t.basis = t.basis.rotated(t.basis.z, deg_to_rad(rot)) if random_enabled and random_randomize_rotation else t.basis
        instance.global_transform = t
        add_child(instance)
        current_offset += randf_range(random_min_distance, random_max_distance) if random_enabled and random_randomize_distance else distance
