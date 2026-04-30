extends Node3D

const LO_QUE_DE_THRESHOLD = 200
const MAX_SPEEDOMETER_SCALE = 2.0
const MAX_SPEEDOMETER_SHAKE = 8.0

var playing = true
var elapsed_time: float = 0.0
#var speedometer_shake: float = 0.0
var original_speedometer_position: Vector2

func _ready() -> void:
    %EndScreen.visible = false
    original_speedometer_position = %SpeedLabel.position

func _physics_process(delta: float) -> void:
    if playing:
        elapsed_time += delta
        %TimeLabel.text = "TIEMPO: %s" % format_time(elapsed_time)
    %SpeedLabel.text = "VELOCIDAD: %s" % format_speed(%PlayerContainer.speed)
    var speed_label_scale: float = lerp(1.0, MAX_SPEEDOMETER_SCALE, inverse_lerp(0.0, LO_QUE_DE_THRESHOLD, %PlayerContainer.speed))
    var speedometer_shake: float = lerp(0.0, MAX_SPEEDOMETER_SHAKE, inverse_lerp(0.0, LO_QUE_DE_THRESHOLD, %PlayerContainer.speed))
    %SpeedLabel.scale = Vector2(speed_label_scale, speed_label_scale)
    %SpeedLabel.position = original_speedometer_position + Vector2(
        randf_range(-speedometer_shake, speedometer_shake),
        randf_range(-speedometer_shake, speedometer_shake),
    )
    
func format_time(seconds: float) -> String:
    var minutes := int(seconds) / 60
    var secs := int(seconds) % 60
    var centiseconds := int((seconds - int(seconds)) * 100)

    return "%02d:%02d.%02d" % [minutes, secs, centiseconds]

func format_speed(meters_per_second: float) -> String:
    var kmh := int(roundf(meters_per_second * 3.6))
    return "%s km/h" % kmh if kmh < LO_QUE_DE_THRESHOLD else "LO QUE DÉ"

func _on_player_finished_track() -> void:
    playing = false
    %FinalTimeLabel.text = format_time(elapsed_time)
    %EndScreen.visible = true

func _on_restart_button_pressed() -> void:
    get_tree().reload_current_scene()
