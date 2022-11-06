shader_type canvas_item;

uniform float rate = 110.0;

uniform vec2 center = vec2(0.5,0.5);
uniform float timer;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	vec2 disp = normalize(SCREEN_UV - center) * timer;
	
	COLOR = texture(SCREEN_TEXTURE,SCREEN_UV-disp);
	}
