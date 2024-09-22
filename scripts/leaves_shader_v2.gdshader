shader_type spatial;
uniform sampler2D text : source_color;
uniform sampler2D wind_noise;
uniform float time_scale = 1.0;
void vertex() {
	VERTEX.x += 6.0;
}

void fragment() {
	float noise_offset = texture(wind_noise, UV/1.0 + TIME * time_scale).r;;
	ALBEDO.rgb = texture(text, UV+vec2(noise_offset,noise_offset)).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
