shader_type spatial;
render_mode unshaded;

uniform float _shield_intensity = 1.0;

float saturate(float x) {
  return max(0, min(1, x));
}

float ComputeFresnel(vec3 norm, vec3 view_dir, float intensity) {
	// dot product between mesh normals and view direction
	float fresnel = 1.0 - dot(norm, view_dir);
	// clamp intensity between 0 and 1
	fresnel = saturate(fresnel);
	// modulate fresnel intensity
	fresnel = pow(fresnel, intensity);
	return fresnel;
}

void fragment() {
	float fresnel = ComputeFresnel(NORMAL, VIEW, _shield_intensity);
	ALPHA *= fresnel;
}
