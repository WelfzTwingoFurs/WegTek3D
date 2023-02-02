extends Node2D

func _physics_process(_delta):
	if Input.is_action_pressed("ply2_up"):
		position += Vector2(0,5).rotated(deg2rad(rotation_degrees))
	
	elif Input.is_action_pressed("ply2_down"):
		position -= Vector2(0,5).rotated(deg2rad(rotation_degrees))
	
	
	if Input.is_action_pressed("ply2_left"):
		if Input.is_action_pressed("ui_select"):
			position -= Vector2(5,0).rotated(deg2rad(rotation_degrees))
		else:
			rotation_degrees -= 5
	
	elif Input.is_action_pressed("ply2_right"):
		if Input.is_action_pressed("ui_select"):
			position += Vector2(5,0).rotated(deg2rad(rotation_degrees))
		else:
			rotation_degrees += 5
	
	
	$base.extraZ[0] = $wheelTL.positionZ
	$base.extraZ[1] = $wheelTR.positionZ
	$base.extraZ[2] = $wheelBR.positionZ
	$base.extraZ[3] = $wheelBL.positionZ
	
	#for n in Children:
	##for m in Children[n].extraZ:
	###Children[n].extraZ[m] = slope(Children[n].points[m], )
	###
