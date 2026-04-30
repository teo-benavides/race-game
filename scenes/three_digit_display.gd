extends HBoxContainer

var value: int:
    set(value):
        for c in get_children():
            c.visible = false
        var digit_1 = get_digit_from_right(value, 0)
        var digit_2 = get_digit_from_right(value, 1)
        var digit_3 = get_digit_from_right(value, 2)
        $Digit1.value = digit_1
        $Digit2.value = digit_2
        $Digit3.value = digit_3
        if digit_3 == 0 and digit_2 == 0:
            $Digit3.visible = false
            $Digit2.visible = false
        elif digit_3 == 0 and digit_2 != 0:
            $Digit3.visible = false
            $Digit2.visible = true
        elif digit_3 != 0:
            $Digit3.visible = true
            $Digit2.visible = true
        $Digit1.visible = true
            

func _ready() -> void:
    value = 0

func get_digit_from_right(n: int, position: int) -> int:
    return int(n / pow(10, position)) % 10
