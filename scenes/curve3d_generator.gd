@tool
extends Path3D

@export var length: float
@export var horizontal_variation: float
@export var forward_interval: float
@export var forward_in_out_variation: float
@export_tool_button("Generate") var generate_action = on_tool_button_clicked

func generate_curve(length: float, horizontal_variation: float, forward_interval: float, forward_in_out_variation: float) -> Curve3D:
    var c = Curve3D.new()
    var points = int(length / forward_interval + 1)
    for p in points:
        var horizontal_variation_sign = 1 if p % 2 == 0 else -1 
        var pos := Vector3(horizontal_variation_sign * horizontal_variation, 0.0, p * forward_interval)
        var in_ := Vector3(0.0, 0.0, -forward_in_out_variation)
        var out := Vector3(0.0, 0.0, forward_in_out_variation)
        c.add_point(pos, in_, out)
    return c
    
func on_tool_button_clicked():
    self.curve = generate_curve(length, horizontal_variation, forward_interval, forward_in_out_variation)
