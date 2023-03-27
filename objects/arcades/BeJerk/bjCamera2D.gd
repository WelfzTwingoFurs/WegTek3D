extends Camera2D

func _process(_delta):
	if Input.is_action_just_pressed("ply_lookup"):
		zoom /= 2
	elif Input.is_action_just_pressed("ply_lookdown"):
		zoom *= 2
