/*
FOR 3D MODELS
*/

shader_type spatial;

//render_mode unshaded;

uniform sampler2D texture_hatch_1 : filter_linear;

void vertex() {
	
}

void fragment() {
	
	vec4 h1 = texture(texture_hatch_1, vec2(1.001f, sin(0.5)) * SCREEN_UV * 5.0);
	h1 *= h1 * h1 * h1;
	
	vec3 xnm = NORMAL;
	vec3 col = vec3(xnm.x + xnm.y + xnm.z) / 3.0;
	//col.x = round(col.x);
	//col.y = round(col.y);
	//col.z = round(col.z);
	
	col.rgb *= 2.1;
	col.rgb *= (floor(6.0 * col.rgb) * 4.0) / 9.0;
	
	ALBEDO.rgb = h1.rgb * col;//mix(h1.rgb, col, 0.7);
	
}

void light() {
	DIFFUSE_LIGHT = vec3(0.5f);
	DIFFUSE_LIGHT = vec3(floor(6.f * DIFFUSE_LIGHT) * 4.f) / 9.f;
}