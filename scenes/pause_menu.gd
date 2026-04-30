extends Control

func _ready() -> void:
    visible = false

func _physics_process(delta: float) -> void:
    if get_tree().current_scene.playing and Input.is_action_just_pressed("pause"):
        get_tree().paused = !get_tree().paused
        visible = get_tree().paused
        AudioServer.set_bus_effect_enabled(0, 0, get_tree().paused)
