extends Node3D
class_name PathSceneSpawner3D

@export var path: Path3D
@export var scene: PackedScene
@export_range(0.001, 99999.0) var distance: float = 1.0
@export var offset: Vector3

func _ready() -> void:
    var curve: Curve3D = path.curve
    
    for i in ceilf(curve.get_baked_length() / distance):
        var t = curve.sample_baked_with_rotation(i * distance)
        var instance = scene.instantiate()
        var local_offset = offset
        t.origin += t.basis * local_offset
        instance.global_transform = t
        add_child(instance)
