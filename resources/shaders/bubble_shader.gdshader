shader_type spatial;

uniform sampler2D noise_texture;
uniform sampler2D color_noise;
uniform vec4 bubble_color : source_color;
uniform float blending_factor = 0.5;
uniform float height_multiplier =0.5;
uniform float noise_sample_size = 0.1;
uniform float animation_speed = 0.05;
varying vec3 world_position;

varying float height;

float fresnel(vec3 normal, mat4 camera_matrix) {
	vec3 view_direction_world = (camera_matrix * vec4(0.0, 0.0, 1.0, 0.0)).xyz;
	vec3 normal_world = (camera_matrix * vec4(normal, 0.0)).xyz;
	
	float d = dot(view_direction_world, normal_world);
	d = abs(d);
	d = clamp(d, 0.0, 1.0);
	
	return 1.0 - d;
}

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	height = texture(noise_texture, VERTEX.xz * noise_sample_size + vec2(TIME) * animation_speed).r;
	VERTEX += NORMAL * height * height_multiplier;
}

void fragment() {
	ROUGHNESS = mix(0.05, 0.1, 1.0 - height);
	SPECULAR = height;
	ALPHA = fresnel(NORMAL, VIEW_MATRIX);
	ALBEDO = 1.0 - (1.0 - bubble_color.rgb * (1.0 - blending_factor)) * (1.0 - texture(color_noise, world_position.xz + vec2(TIME * animation_speed)).rgb * blending_factor);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
