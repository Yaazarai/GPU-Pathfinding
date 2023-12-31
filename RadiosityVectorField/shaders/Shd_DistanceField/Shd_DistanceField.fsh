varying vec2 in_FragCoord;

#define V2F16(v) ((v.y * float(0.0039215686274509803921568627451)) + v.x)
#define F16V2(f) vec2(floor(f * 255.0) * float(0.0039215686274509803921568627451), fract(f * 255.0))

void main() {
    vec4 jfuv = texture2D(gm_BaseTexture, in_FragCoord);
    vec2 jumpflood = vec2(V2F16(jfuv.rg),V2F16(jfuv.ba));
    float dist = distance(in_FragCoord, jumpflood);
	gl_FragColor = vec4(F16V2(dist), 0.0, 1.0);
}