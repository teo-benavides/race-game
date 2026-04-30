extends HBoxContainer

var seconds: float:
    set(value):
        var mins = get_minutes(value)
        var secs = get_seconds(value)
        var cents = get_centiseconds(value)
        $MinutesDigit1.value = get_digit_from_right(mins, 0)
        $MinutesDigit2.value = get_digit_from_right(mins, 1)
        $SecondsDigit1.value = get_digit_from_right(secs, 0)
        $SecondsDigit2.value = get_digit_from_right(secs, 1)
        $CentisecondsDigit1.value = get_digit_from_right(cents, 0)
        $CentisecondsDigit2.value = get_digit_from_right(cents, 1)
            
func _ready() -> void:
    seconds = 0

func get_digit_from_right(n: int, position: int) -> int:
    return int(n / pow(10, position)) % 10
    
func get_minutes(seconds: float) -> int:
    return int(seconds) / 60

func get_seconds(seconds: float) -> int:
    return int(seconds) % 60

func get_centiseconds(seconds: float) -> int:
    return int((seconds - int(seconds)) * 100)
