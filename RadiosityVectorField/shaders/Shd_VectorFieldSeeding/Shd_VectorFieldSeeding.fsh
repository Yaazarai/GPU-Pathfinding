varying vec2 in_FragCoord;

#define EPSILON 0.0001
#define F16V2(f) vec2(floor(f * 255.0) * float(0.0039215686274509803921568627451), fract(f * 255.0))

void main() {
    vec4 scene = texture2D(gm_BaseTexture, in_FragCoord);
	float hastarget = sign(max(scene.r, max(scene.g, scene.b)));
	if (hastarget > EPSILON) {
		gl_FragColor = vec4(F16V2(0.0), hastarget, hastarget);
	} else {
		gl_FragColor = scene;
	}
}