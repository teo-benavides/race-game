shader_type spatial;

uniform sampler2D albedo_texture : source_color, filter_linear_mipmap;
uniform float scroll_speed : hint_range(0.0, 10.0) = 1.0;
uniform float alpha = 1.0;
void fragment() {
    vec2 uv = UV;
    uv.y += TIME * scroll_speed; // subtract → scroll upward

    vec4 tex = texture(albedo_texture, uv);
    ALBEDO = tex.rgb;
    ALPHA  = alpha;
}