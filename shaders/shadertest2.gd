extends ColorRect

func _ready():
	material = material.duplicate()


var timer = 0.0

func _process(_delta):
	material.set_shader_param("timer", timer)
	if Input.is_action_pressed("ply_up"):
		if Input.is_action_pressed("ctrl"):
			timer += 0.0001
		else:
			timer += 0.001#lerp(timer, 1.0, 0.05)
	elif Input.is_action_pressed("ply_down"):
		if Input.is_action_pressed("ctrl"):
			timer -= 0.0001
		else:
			timer -= 0.001#lerp(timer, 0.0, 0.05)
