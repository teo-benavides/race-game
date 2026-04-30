extends Node3D

const LO_QUE_DE_THRESHOLD = 350
const SPEED_MULTIPLIER = 2.0

var playing = true
var elapsed_time: float = 0.0

func _ready() -> void:
    %HUD.visible = true
    %EndScreen.visible = false
    %HitEffect.visible = false
    %GoalContainer.progress_ratio = 0.995

func _physics_process(delta: float) -> void:
    if playing:
        elapsed_time += delta
        %TimeDisplay.seconds = elapsed_time
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
