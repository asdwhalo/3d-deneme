// This shader was created by Akio, also known as "tqef".
// You are always free to use this shader, but please consider crediting me!
// Thanks for using my shader in your personal projects <3
shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque;

uniform vec4 albedo_color : source_color = vec4(0.95, 0.85, 0.35, 1.0);
uniform sampler2D albedo_tex : source_color;
uniform bool use_albedo_tex = false;

uniform vec4 specular_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float spec_intensity : hint_range(0.0, 2.0) = 0.9;
uniform float shininess : hint_range(1.0, 128.0) = 36.0;

uniform float rim_intensity : hint_range(0.0,1.0) = 0.08;
uniform float rim_power : hint_range(0.5,8.0) = 3.0;

varying vec3 world_position;
varying vec3 world_normal;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
	ALPHA_HASH_SCALE = 1.0;
	// base color (texture optional)
	vec4 base = albedo_color;
	if (use_albedo_tex) {
		base *= texture(albedo_tex, UV);
	}

	// WORLD-space normal and view vector
	vec3 N = normalize(world_normal);                         // surface normal (world space)
	vec3 V = normalize(CAMERA_POSITION_WORLD - world_position); // view vector from fragment -> camera

	// Fake specular highlight:
	// We don't use engine lights (unshaded). Emulate a glossy spot by
	// computing a simple Blinn-like specular with a fixed "light" in view direction.
	vec3 H = normalize(V + vec3(0.0, 0.0, 1.0)); // half-vector biased toward camera-front
	float spec = pow(max(dot(N, H), 0.0), shininess);
	vec3 spec_contrib = specular_color.rgb * (spec * spec_intensity);

	// Small rim highlight (gives that toy/plastic silhouette sheen)
	float rim = pow(1.0 - max(dot(N, V), 0.0), rim_power) * rim_intensity;
	vec3 rim_contrib = specular_color.rgb * rim;

	// Combine and output
	ALBEDO = base.rgb + spec_contrib + rim_contrib;
	ALPHA = base.a;
}