shader_type spatial;

uniform vec3 _origin = vec3(1.0, 0.0, 0.0);
uniform float _frequency = 5.0;
uniform float _density = 5.0;
uniform float _amplitude = 6.0;
uniform float _blend = 0;
uniform float _radius = 1.1;
uniform float _anim = 0.0;

float _GetRippleOrigin(vec3 vert, vec3 orig) {
	// distance of each vertex from the origin
	return length(orig - vert);
}

float _FadeRipple(float orig, float blend, float radius) {
	// create a radius 
	float b = clamp(blend, 0.0, radius);
	return smoothstep(b, -radius, orig);
}

float _ComputeRipple(vec3 vert, vec3 orig, float blend, float radius, float freq, float dens, float ampl, float anim) {
	// calculate the intensity of the
	float o = _GetRippleOrigin(vert, orig);
	float i = sin(anim * freq - o * dens) / ampl;
	return i * _FadeRipple(o, blend, radius);
}

void vertex() {	
	// Local to World conversion to add ripple
	vec3 w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// normalize origin vector
	vec3 imp_or = normalize(_origin);
	
	float _ripple = _ComputeRipple(w_pos, 
		_origin, 
		_blend,
		_radius, 
		_frequency, 
		_density, 
		_amplitude,
		TIME);
	
	VERTEX += NORMAL * _ripple;
}

void fragment() {
	ALBEDO = vec3(1.0, 1.0, 1.0);
	SPECULAR = 0.0;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
}