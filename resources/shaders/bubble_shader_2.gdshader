shader_type spatial;
uniform sampler2D noise_texture;
uniform float smoothness : hint_range(0.0, 1.0, 0.01);
uniform float animation_speed = 0.05;
uniform sampler2D color;
uniform vec4 bubble_color : source_color;
varying vec3 world_position;
float fresnel(vec3 normal, mat4 camera_matrix){
	vec3 view_direction_world = (camera_matrix * vec4(0.0, 0.0, 1.0, 0.0)).xyz;
	vec3 normal_world = (camera_matrix * vec4(normal, 0.0)).xyz;
	float fresnel = dot(view_direction_world,normal_world);
	fresnel = clamp(abs(fresnel), 0.0, 1.0);
	return 1.0 - fresnel;
}
void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float height = texture(noise_texture, VERTEX.xz * smoothness + vec2(TIME * animation_speed)).r;
	VERTEX += NORMAL * height;

}

void fragment() {
	float fresnel = fresnel(NORMAL, VIEW_MATRIX);
	ALBEDO = mix(bubble_color.rgb, texture(color, world_position.xz + vec2(TIME * animation_speed)).rgb, 0.2);
	ROUGHNESS = 0.05;
	ALPHA = fresnel;








}