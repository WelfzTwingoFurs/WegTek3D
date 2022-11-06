shader_type canvas_item;

uniform float timer = 0.0;
uniform float rate = 110.0;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	vec2 new = 0.1-UV;
	
	
	COLOR = texture(TEXTURE,new);
	}

//UV.x/TEXTURE_PIXEL_SIZE.x to get the value of UV.x in actual pixels
//float random(vec2 _st) {
//	return fract(sin(dot(_st.xy, vec2(12.9898,78.233))) * 43758.5453123);
//}
	//float sintime = sin(TIME);
	//float rand1 = random(UV);
	//float rand2 = random(vec2(sintime,sintime));
