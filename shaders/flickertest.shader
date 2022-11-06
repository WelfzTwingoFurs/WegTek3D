shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	
	if (COLOR.a != 0.0) {
		if (int((TIME)*10.0) % 2 == 0) {
			COLOR.a = 0.0;}
			}
	}