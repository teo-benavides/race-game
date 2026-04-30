extends Control

var value: int:
    set(value):
        for c in get_children():
            c.visible = false
        get_node(str(value)).visible = true

func _ready() -> void:
    for c in get_children():
        c.visible = false
