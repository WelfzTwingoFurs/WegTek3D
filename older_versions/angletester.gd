extends CollisionShape2D

var input_dir = Vector2(0,0)
var rotation_angle = 0

func deg_rad(N):
	N *= PI/180
	return N

func rad_overflow(N):
	if N > PI*2:
		N -= PI*2
	elif N < 0:
		N += PI*2
	
	return N

func _ready():
	VisualServer.set_default_clear_color(Color(0.1,0,0))
	
	$Label157.set_position(Vector2(0,shape.radius*1.8).rotated(PI/2))
	$Label157.text = str(PI/2)
	$Label314.set_position(Vector2(0,shape.radius*1.8).rotated(PI))
	$Label314.text = str(PI)
	$Label471.set_position(Vector2(0,shape.radius*1.8).rotated(3*PI/2))
	$Label471.text = str(3*PI/2)
	$Label628.set_position(Vector2(0,shape.radius*1.8).rotated(PI*2))
	$Label628.text = str(PI*2)
	
	$Position2D.position = Vector2(shape.radius+(randi() % int(shape.radius)), shape.radius+(randi() % int(shape.radius))).rotated(randi() & int(PI*2))

func _process(_delta):
	if Input.is_action_pressed("bug_rotatecenter"):
		if Input.is_action_pressed("ui_down"): #down
			rotation_angle = 0
		elif Input.is_action_pressed("ui_up"): #up
			rotation_angle = PI
		elif Input.is_action_pressed("ui_left"): #left
			rotation_angle = 0.5*PI
		elif Input.is_action_pressed("ui_right"): #right
			rotation_angle = 1.5*PI
	
	elif Input.is_action_pressed("ui_left"):
		rotation_angle -= 0.00872665 #0.0174533 #1 degree in radian
		if rotation_angle < 0:
			rotation_angle = 2*PI #360 in radian
	elif Input.is_action_pressed("ui_right"):
		rotation_angle += 0.00872665 #0.0174533 #1 degree in radian
		if rotation_angle > 2*PI: #360 in radian
			rotation_angle = 0
	
	if Input.is_action_pressed("mouse1"):
		$Position2D.position = get_global_mouse_position()
	
	#var uh = OS.get_system_time_msecs()/50
	#$math.modulate = Color(abs(sin(uh)), abs(sin(uh)+sin(OS.get_system_time_secs())), abs(sin(OS.get_system_time_secs()))+sin(uh))
	
	
	update()
	$math.set_position(Vector2(-OS.window_size.x,-shape.radius*2.5))
	$math.margin_right = OS.window_size.x
	
	$Label.set_position(Vector2(0,shape.radius).rotated(rotation_angle))
	$Label.text = str(rotation_angle)
	
	$LabelPLUS.set_position(Vector2(0,shape.radius).rotated(rotation_angle+PI/2))
	$LabelPLUS.text = str(rad_overflow(rotation_angle+PI/2))
	
	$LabelMINUS.set_position(Vector2(0,shape.radius).rotated(rotation_angle-PI/2))
	$LabelMINUS.text = str(rad_overflow(rotation_angle-PI/2))
	
	
	$LabelPOS.set_position($Position2D.position)
	#$LabelPOS.text = str(($Position2D.position-position).angle())
	$LabelPOS.text = str(rad_overflow(($Position2D.position-position).angle()-PI/2))
	
	$LabelDIS.set_position($Position2D.position/2)
	$LabelDIS.text = str("\n", sqrt(pow(($Position2D.position.x - position.x), 2) + pow(($Position2D.position.y - position.y), 2)) )
	
	
	#if rad_overflow(rotation_angle-PI/2) < rad_overflow(rotation_angle+PI/2): # 90 < rot < 270
	if rotation_angle > PI/2 && rotation_angle < 3*PI/2:
		#print("RED PLUS IS BIGGEST")
		$math.text = str("rad_overflow(($Position2D.position-position).angle()-PI/2) < rad_overflow(rotation_angle-PI/2) or rad_overflow(($Position2D.position-position).angle()-PI/2) > rad_overflow(rotation_angle+PI/2):\n",
		rad_overflow(($Position2D.position-position).angle()-PI/2)," < ",rad_overflow(rotation_angle-PI/2)," or ",rad_overflow(($Position2D.position-position).angle()-PI/2)," > ",rad_overflow(rotation_angle+PI/2))
		$math.modulate = Color(1,0,0)
		
		
		if rad_overflow(($Position2D.position-position).angle()-PI/2) < rad_overflow(rotation_angle-PI/2) or rad_overflow(($Position2D.position-position).angle()-PI/2) > rad_overflow(rotation_angle+PI/2):
			#print("!!RED ALERT!!")
			
			if abs(randi() % 2) == 0:
				$LabelPOS.modulate = Color(1,1,1)
				$math.modulate = Color(1,0.5,0.5)
			else:
				$LabelPOS.modulate = Color(0,1,0)
				$math.modulate = Color(1,0,0)
			
		else:
			$LabelPOS.modulate = Color(0,1,0)
	
	else:
		#print("PINK MINUS IS BIGGER")
		$math.modulate = Color(1,0.5,1)
		$math.text = str("rad_overflow(($Position2D.position-position).angle()-PI/2) < rad_overflow(rotation_angle-PI/2) && rad_overflow(($Position2D.position-position).angle()-PI/2) > rad_overflow(rotation_angle+PI/2):\n",
		rad_overflow(($Position2D.position-position).angle()-PI/2)," < ",rad_overflow(rotation_angle-PI/2)," && ",rad_overflow(($Position2D.position-position).angle()-PI/2)," > ",rad_overflow(rotation_angle+PI/2))
		$math.modulate = Color(1,0,1)
		
		
		if rad_overflow(($Position2D.position-position).angle()-PI/2) < rad_overflow(rotation_angle-PI/2) && rad_overflow(($Position2D.position-position).angle()-PI/2) > rad_overflow(rotation_angle+PI/2):
			#print("!!PINK ALERT!!")
			if abs(randi() % 2) == 0:
				$LabelPOS.modulate = Color(1,1,1)
				$math.modulate = Color(1,0.5,1)
			else:
				$LabelPOS.modulate = Color(0,1,0)
				$math.modulate = Color(1,0,1)
			
		else:
			$LabelPOS.modulate = Color(0,1,0)

func _draw():
	draw_line(Vector2(0,0), Vector2(0,shape.radius).rotated(rotation_angle), Color(1,1,1), 1)
	
	#draw_line(Vector2(0,shape.radius).rotated(rotation_angle+PI/2), Vector2(0,shape.radius).rotated(rotation_angle-PI/2), Color(1,0,0), 1)
	draw_line(Vector2(0,0), Vector2(0,shape.radius).rotated(rotation_angle+PI/2), Color(1,0,0), 1)
	draw_line(Vector2(0,0), Vector2(0,shape.radius).rotated(rotation_angle-PI/2), Color(1,0,1), 1)
	
	#draw_line(Vector2(0,0), $Position2D.position, Color(randi() % 2, 1, 0), 1)
	draw_line(Vector2(0,0), $Position2D.position, $LabelPOS.modulate, 1)
	
	
	
	###
	draw_line(Vector2(0,shape.radius), Vector2(0,9999), Color(0,1,1), 1)
	draw_line(Vector2(0,-shape.radius), Vector2(0,-9999), Color(0,0,1), 1)
	
	draw_line(Vector2(shape.radius,0), Vector2(9999,0), Color(0,0,1), 1)
	draw_line(Vector2(-shape.radius,0), Vector2(-9999,0), Color(0,0,1), 1)
