shader_type canvas_item;

uniform float timer = 0.0;
uniform float rate = 110.0;

void fragment() {
	//if (COLOR.a != 0.0) {
		//COLOR.a = 1.0-timer;
	COLOR = texture(TEXTURE,UV);
	vec2 new = UV;
	
	if (COLOR.a != 0.0) {
	if (int(UV.x*timer*rate) % 2 == 0) {
	//if (int(UV.x*10.0) % 2 == 0) {
		new.x = UV.x+timer;}
	else {
		new.x = UV.x-timer;}
	
	if (int(UV.y*timer*rate) % 2 == 0) {
	//if (int(UV.y*10.0) % 2 == 0) {
		new.y = UV.y+timer;}
	else {
		new.y = UV.y-timer;}
	
	COLOR = texture(TEXTURE,new);}
	//	} 
	}

//UV.x/TEXTURE_PIXEL_SIZE.x to get the value of UV.x in actual pixels
//float random(vec2 _st) {
//	return fract(sin(dot(_st.xy, vec2(12.9898,78.233))) * 43758.5453123);
//}
	//float sintime = sin(TIME);
	//float rand1 = random(UV);
	//float rand2 = random(vec2(sintime,sintime));
