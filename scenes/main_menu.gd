extends Control

var is_in_lore = false

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("start"):
        if is_in_lore:
            get_tree().change_scene_to_file("res://scenes/main.tscn")
        else:
            is_in_lore = true
            $LoreTexture.visible = true
            $LoreButton.visible = true

func _on_start_button_pressed() -> void:
    is_in_lore = true
    $LoreTexture.visible = true
    $LoreButton.visible = true

func _on_start_button_mouse_entered() -> void:
    $JugarOn.visible = true

func _on_start_button_mouse_exited() -> void:
    $JugarOn.visible = false


func _on_lore_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")
