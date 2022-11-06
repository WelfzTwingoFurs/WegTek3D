shader_type canvas_item;

uniform float rate = 110.0;

uniform vec2 center;
uniform float timer;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	vec2 disp = normalize(UV - center) * timer;
	
	COLOR = texture(TEXTURE,UV-disp);
	}
