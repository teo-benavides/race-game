shader_type spatial;
render_mode depth_draw_always, blend_mix;

uniform vec4 main_color : source_color;
uniform sampler2D noise_texture : source_color;
uniform vec4 emission : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float emission_energy = 1.0;
uniform float scroll_speed = 1.0;

uniform float alpha_threshold = 0.0;
uniform bool use_threshold = false;
uniform bool invert_boost_direction = false;

uniform bool fade_emission = true;

/*
fade_mode:
0 = Cylinder end fade (independent top/bottom)
1 = Box edge fade (independent -X/+X/-Z/+Z)
*/
uniform int fade_mode = 0;

/* Feathering in local units */
uniform float fade_softness : hint_range(0.0001, 1.0) = 0.02;

/* =========================
   CYLINDER (local units)
   =========================
For your cylinder height = 0.4 -> half height = 0.2
*/
uniform float cylinder_half_height : hint_range(0.0, 100.0) = 0.2;

/* Independent end fade depths (how far it fades inward from each end) */
uniform float cylinder_fade_bottom : hint_range(0.0, 10.0) = 0.10; // y = -half_height
uniform float cylinder_fade_top    : hint_range(0.0, 10.0) = 0.05; // y = +half_height

/* =========================
   BOX (local units)
   =========================
For size (1, 0.01, 1) -> half extents (0.5, 0.005, 0.5)
*/
uniform vec3 box_half_extents = vec3(0.5, 0.005, 0.5);

/* Independent side fades */
uniform float box_fade_x_neg : hint_range(0.0, 1.0) = 0.12; // left  (-X)
uniform float box_fade_x_pos : hint_range(0.0, 1.0) = 0.12; // right (+X)
uniform float box_fade_z_neg : hint_range(0.0, 1.0) = 0.12; // back  (-Z)
uniform float box_fade_z_pos : hint_range(0.0, 1.0) = 0.12; // front (+Z)

/* (Optional) if you ever want thickness/top/bottom fades, enable later:
uniform float box_fade_y_neg : hint_range(0.0, 1.0) = 0.0;
uniform float box_fade_y_pos : hint_range(0.0, 1.0) = 0.0;
*/

varying vec3 v_local_pos;

void vertex() {
	v_local_pos = VERTEX; // local/object space
}

float soft_edge(float dist_to_edge, float depth, float softness) {
	if (depth <= 0.0) return 1.0;
	float s = max(softness, 1e-6);
	return smoothstep(0.0, depth + s, dist_to_edge);
}

void fragment() {
	// Noise scroll (UV only for sampling; fade uses local position)
	vec2 moving_uv = UV;
	if (invert_boost_direction) moving_uv.y += TIME * scroll_speed;
	else moving_uv.y -= TIME * scroll_speed;

	vec4 n = texture(noise_texture, moving_uv);
	float noise_value = n.r;

	float fade_mask = 1.0;

	if (fade_mode == 0) {
    // ===== Top-to-bottom directional fade =====
    // Normalized 0.0 (top, y = +half_height) → 1.0 (bottom, y = -half_height)
    float t = (cylinder_half_height - v_local_pos.y) / (2.0 * cylinder_half_height);
    t = clamp(t, 0.0, 1.0);

    // Remap so the fade starts sharp at top and feathers over fade_softness range
    float ramp_start = 0.0;                          // where effect begins (top)
    float ramp_end   = cylinder_fade_top;            // how far down it takes to fully appear
    fade_mask = smoothstep(ramp_start, ramp_end, t);

    // Optional: still fade out near the bottom using cylinder_fade_bottom
    float dist_bottom = (v_local_pos.y + cylinder_half_height) / (2.0 * cylinder_half_height);
    float bottom_ramp = 1.0 - cylinder_fade_bottom;
    float fb = smoothstep(bottom_ramp - fade_softness, bottom_ramp, 1.0 - dist_bottom);
    fade_mask *= (1.0 - fb);

	} else {
		// ===== Box independent sides (-X/+X/-Z/+Z) =====
		float dist_x_neg = (v_local_pos.x + box_half_extents.x); // from -X side
		float dist_x_pos = (box_half_extents.x - v_local_pos.x); // from +X side
		float dist_z_neg = (v_local_pos.z + box_half_extents.z); // from -Z side
		float dist_z_pos = (box_half_extents.z - v_local_pos.z); // from +Z side

		float fxn = soft_edge(dist_x_neg, box_fade_x_neg, fade_softness);
		float fxp = soft_edge(dist_x_pos, box_fade_x_pos, fade_softness);
		float fzn = soft_edge(dist_z_neg, box_fade_z_neg, fade_softness);
		float fzp = soft_edge(dist_z_pos, box_fade_z_pos, fade_softness);

		fade_mask = fxn * fxp * fzn * fzp;
	}

	ALBEDO = main_color.rgb;

	vec3 emiss = emission.rgb * emission_energy * n.rgb;
	if (fade_emission) emiss *= fade_mask;
	EMISSION = emiss;

	float alpha = main_color.a * noise_value * fade_mask;

	if (use_threshold && alpha < alpha_threshold) discard;
	else ALPHA = alpha;
}
