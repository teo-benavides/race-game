extends Control

var value: int:
    set(value):
        for c in $Contents.get_children():
            c.visible = false
        if value == -1:
            $Contents/Kmh.visible = false
            $Contents/ThreeDigitDisplay.visible = false
            $Contents/LoQueDe.visible = true
        else:
            $Contents/ThreeDigitDisplay.value = value
            $Contents/Kmh.visible = true
            $Contents/ThreeDigitDisplay.visible = true
            $Contents/LoQueDe.visible = false

func _ready() -> void:
    value = 0
