shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D water_texture;
uniform sampler2D warp_texture;

vec2 stepify(vec2 a, vec2 step_size) {
	vec2 d = a/step_size;
	return vec2(float(int(d.x)), float(int(d.y)))*step_size;
}

void fragment() {
	vec2 wrap = vec2(1.0, 1.0);
	float t = TIME*0.05;
	vec2 uv = UV + vec2(t, t);
	uv += vec2(0.0, texture(warp_texture, UV).r)*0.05;
	uv = modf(uv, wrap);
	COLOR = texture(water_texture, uv);
}
