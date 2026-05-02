extends Node3D

var warning_indicator_scene := preload("res://scenes/warning_indicator.tscn") as PackedScene

const LO_QUE_DE_THRESHOLD := 350
const SPEED_MULTIPLIER := 2.0
const OBSTACLE_LOOKAHEAD_DISTANCE := 30.0
const OBSTACLE_WARNINGS_ENABLED = false

var playing = true
var elapsed_time: float = 0.0

func _ready() -> void:
    %HUD.visible = true
    %RotatingVehicle.position = Vector2(125.0, -144.0)
    %EndScreen.visible = false
    %HitEffect.visible = false
    %GoalContainer.progress_ratio = 0.995


func _process(delta: float) -> void:
    if !playing and Input.is_action_just_pressed("start"):
        get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
    if playing:
        elapsed_time += delta
        %TimeDisplay.seconds = elapsed_time
    
    if OBSTACLE_WARNINGS_ENABLED:
        var obj_infos := %ObstacleSpawner.get_object_infos_in_range(%PathFollow.progress, %PathFollow.progress + OBSTACLE_LOOKAHEAD_DISTANCE) as Array[PathObjectInfo]
        for c in %WarningIndicatorHolder.get_children():
            c.queue_free()
        for obj_info in obj_infos:
            var indicator = warning_indicator_scene.instantiate()
            indicator.position = Vector2.UP.rotated(deg_to_rad(-obj_info.rotation)) * 100.0
            %WarningIndicatorHolder.add_child(indicator)
        %WarningIndicatorHolder.rotation = %PlayerContainer.rotation.z
    
    var kmh := int(roundf(%PlayerContainer.speed * SPEED_MULTIPLIER * 3.6))
    %Speedometer.value = kmh if kmh < LO_QUE_DE_THRESHOLD else -1
    
func format_time(seconds: float) -> String:
    var minutes := int(seconds) / 60
    var secs := int(seconds) % 60
    var centiseconds := int((seconds - int(seconds)) * 100)

    return "%02d:%02d.%02d" % [minutes, secs, centiseconds]

func _on_player_finished_track() -> void:
    playing = false
    %PlayerContainer.set_physics_process(false)
    %EndScreenTimeDisplay.seconds = elapsed_time
    %EndScreen.visible = true

func _on_restart_button_pressed() -> void:
    get_tree().reload_current_scene()

func _on_player_died() -> void:
    %HitEffect.visible = true
    $HitEffectTimer.start()

func _on_hit_effect_timer_timeout() -> void:
    %HitEffect.visible = false
