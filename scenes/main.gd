extends Node3D

var playing = true
var elapsed_time: float = 0.0

func _ready() -> void:
    %EndScreen.visible = false

func _physics_process(delta: float) -> void:
    if playing:
        elapsed_time += delta
        %TimeLabel.text = "TIEMPO: %s" % format_time(elapsed_time)

    
func format_time(seconds: float) -> String:
    var minutes := int(seconds) / 60
    var secs := int(seconds) % 60
    var centiseconds := int((seconds - int(seconds)) * 100)

    return "%02d:%02d.%02d" % [minutes, secs, centiseconds]

func _on_player_finished_track() -> void:
    playing = false
    %FinalTimeLabel.text = format_time(elapsed_time)
    %EndScreen.visible = true

func _on_restart_button_pressed() -> void:
    get_tree().reload_current_scene()
