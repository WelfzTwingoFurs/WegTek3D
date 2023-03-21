extends KinematicBody2D

var motion = Vector2()
export var angles = 145
export var draw_distance = 8192

func _ready():
	Worldconfig.Camera2D = $Camera2D
	Worldconfig.player = self
	$ViewArea/ViewCol.polygon = [Vector2(0,0),Vector2(0,draw_distance*2).rotated(-deg2rad(angles/2)),Vector2(0,draw_distance*2).rotated( deg2rad(angles/2))]


################################################################################

var angle
var position3D = Vector3()
var positionZ = 0
var move = Vector2()

func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	angle = deg2rad($ViewArea.rotation_degrees)
	
	motion = Vector2(move.x,move.y).rotated(angle)
	
	if !Input.is_action_pressed("ply_strafe"):
		move.x = 0
		if Input.is_action_pressed("ply_left"):
			$ViewArea.rotation_degrees = deg_overflow($ViewArea.rotation_degrees-1)
		elif Input.is_action_pressed("ply_right"):
			$ViewArea.rotation_degrees = deg_overflow($ViewArea.rotation_degrees+1)
	else:
		if Input.is_action_pressed("ply_left"):
			move.x = 1000
		elif Input.is_action_pressed("ply_right"):
			move.x = -1000
		else:
			move.x = 0
	
	
	if Input.is_action_pressed("ply_up"):
		move.y = 1000
	elif Input.is_action_pressed("ply_down"):
		move.y = -1000
	else:
		move.y = 0
	
	if Input.is_action_pressed("ply_jump"):
		positionZ += 1
	elif Input.is_action_pressed("ply_crouch"):
		positionZ -= 1
	
	position3D = Vector3(position.x,position.y,positionZ)


################################################################################


var container

func _process(_delta):
	$PolyContainer.scale.x = abs((OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated(-deg2rad((angles)/2)) ).angle() ))) - (OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated( deg2rad((angles)/2)) ).angle() ))))
	$PolyContainer.scale.y = $PolyContainer.scale.x/not_zero(OS.window_size.y)
	
	if (weakref(container).get_ref()):
		container.queue_free()
		
	container = $PolyContainer.duplicate()
	add_child(container)
	
	var midscreen = (Vector2(0,draw_distance).rotated(angle)).angle()
	
	
	for n in walls.size():
		for m in walls[n].polygon.size()-2:
			var new1 = $PolyContainer/Sprite0.duplicate()
			var polygon2D = (Vector2(walls[n].polygon[m].x, walls[n].polygon[m].y))
			
			var x = (polygon2D - position).angle() - midscreen
			var y = (OS.window_size.y / not_zero( (polygon2D - position).length()) )   /  cos(x)
			
			#new1.scale = Vector2( ((((OS.window_size.x /  not_zero((polygon2D - position).length())) / cos(x) )/$PolyContainer.scale.x) * (180-angles)/1000), y)
			new1.scale = Vector2(1/container.scale.x, y)
			new1.position = Vector2(tan(x), ((positionZ)*y)-y*(walls[n].polygon[m].z) )
			new1.z_index = (walls[n].polygon[m] - position3D).length()
			
			#new1.texture = walls[n].texture
			#new1.hframes = new1.texture.get_width()
			
			container.add_child(new1)
			############################################################ strip 1
			var new2 = new1.duplicate()
			polygon2D = (Vector2(walls[n].polygon[loop(m+1, walls[n].polygon.size())].x, walls[n].polygon[loop(m+1, walls[n].polygon.size())].y))
			
			x = (polygon2D - position).angle() - midscreen
			y = (OS.window_size.y / not_zero( (polygon2D - position).length()) )   /  cos(x)
			
			#new2.scale = Vector2( ((((OS.window_size.x /  not_zero((polygon2D - position).length())) / cos(x) )/$PolyContainer.scale.x) * (180-angles)/1000), y)
			new2.scale = Vector2(1/container.scale.x, y)
			new2.position = Vector2(tan(x), ((positionZ)*y)-y*(walls[n].polygon[loop(m+1, walls[n].polygon.size())].z) )
			new2.z_index = (walls[n].polygon[loop(m+1, walls[n].polygon.size())] - position3D).length()
			
			container.add_child(new2)
			############################################################ strip 2
			
			
			var Min = Vector2([new1.position.x, new2.position.x].min(), [new1.position.y, new2.position.y].min())
			var Max = Vector2([new1.position.x, new2.position.x].max(), [new1.position.y, new2.position.y].max())
			
			for o in ((Max.x-Min.x)*container.scale.x):
				var mid = new1.duplicate()
				mid.modulate = Color8(o,o,o)
				mid.position.x = Max.x-(o/container.scale.x)
				container.add_child(mid)
				#sprites.push_back(mid)

#var sprites = []

################################################################################


var walls = []

func _on_ViewArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("render"):
		if !walls.has(body):
			walls.push_back(body)


func _on_ViewArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if walls.has(body):
		walls.erase(body)


################################################################################


func rad_overflow(N):
	if N > PI*2:
		N -= PI*2
	elif N < 0:
		N += PI*2
	
	return N

func deg_overflow(N):
	if N > 360:
		N -= 360
	elif N < 360:
		N += 360
	
	return N

func loop(to_check, array_size):
	if to_check < 0:
		to_check += array_size
	
	if to_check > array_size-1:
		to_check -= array_size
	
	
	if (to_check < 0) or (to_check > array_size-1):
		to_check = loop(to_check, array_size)
	
	return(to_check)

func not_zero(n):
	if n == 0:
		return 1
	else:
		return n



func overflow(N, minn, maxx):
	while N > maxx:
		N -= range(minn, maxx).size()
	
	while N < minn:
		N += range(minn, maxx).size()
	
	return N

