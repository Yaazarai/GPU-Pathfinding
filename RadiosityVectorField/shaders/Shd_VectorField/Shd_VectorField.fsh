varying vec2      in_FragCoord;
uniform float     in_Resolution;
uniform sampler2D in_DistanceField;

#define RAYSTEPS 32.0
#define EPSILON  0.0001
#define TAU      float(6.2831853071795864769252867665590)
#define V2F16(v) ((v.y * float(0.0039215686274509803921568627451)) + v.x)
#define F16V2(f) vec2(floor(f * 255.0) * float(0.0039215686274509803921568627451), fract(f * 255.0))

float raymarch(inout vec2 pix, vec2 dir, out float raydist) {
	for(float dist = 0.0, i = 0.0; i < RAYSTEPS; i += 1.0, pix += dir * dist) {
		raydist += dist = V2F16(texture2D(in_DistanceField, pix).rg);
		if (dist < EPSILON) return 1.0;
	}
	
	return 0.0;
}

void main() {
    vec2 sdf = texture2D(in_DistanceField, in_FragCoord).rg;
	vec4 rvfp = texture2D(gm_BaseTexture, in_FragCoord).rgba;
	
	if (V2F16(sdf) >= EPSILON) {
		float hastarget = 0.0, mindist = in_Resolution * in_Resolution;
		for(float raydist = 0.0, ray = 0.0; ray < TAU; ray += TAU / 4.0) {
			vec2 pixel = in_FragCoord;
			float rayhit = raymarch(pixel, vec2(cos(ray), -sin(ray)), raydist);
			vec4 target = texture2D(gm_BaseTexture, pixel).rgba;
			
			if ((rayhit * target.b) > EPSILON) {
				mindist = min(mindist, V2F16(target.rg) + raydist);
				// TESTING: // mindist = min(mindist, target.r + raydist);
				hastarget = 1.0;
			}
		}
		
		rvfp = vec4(F16V2(mindist), hastarget, hastarget);
		// TESTING: // rvfp = vec4(mindist, 1.0 - mindist, hastarget, hastarget);
	}

	gl_FragColor = rvfp;
}