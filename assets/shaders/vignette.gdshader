shader_type canvas_item;

uniform vec4 color: source_color;
uniform float multiplier = 0.2;
uniform float softness = 3.0f;

void fragment() {
	// Place fragment code here.
	float value = distance(UV, vec2(0.5));
	COLOR  = vec4(color.rgb, smoothstep(multiplier, softness, value));
}
