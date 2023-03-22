extends Area2D

var on = 0

func _on_car_custom_body_entered(body):
	if body == Worldconfig.playercar:
		on = 1
		Worldconfig.menu = self

var pos = 0
var pos2 = 0
var max_pos = 14
var string = str("...")
var menu_string_array = ["top","\ninside","\nside-L","\nside-R","\nfront","\nback","\nhood","\ntrunk","\nwindow","\nrearlight","\nheadlight","\nwheel-LB","\nwheel-LF","\nwheel-RB","\nwheel-RF"]
var menu_color_array = [Color(),Color(),Color(),Color(),Color(),Color(),Color(),Color(),Color(),Color(),Color(),Color(),Color(),Color()]
export var myname = str("MHD Customs\n")
var copy = Color()

func _process(_delta):
	if Worldconfig.playercar == null:
		$CollisionPolygon2D.disabled = true
	else:
		$CollisionPolygon2D.disabled = false
	
	if on && (Worldconfig.playercar != null):
		if on == 2:
			string = str(myname," <Pick color>  //  ^RGBv [",pos2,"/2]\nR:",menu_color_array[pos].r," G:",menu_color_array[pos].g," B:",menu_color_array[pos].b,"\n\nClipboard:",copy)
			
			
			if Input.is_action_just_pressed("ply_down"):
				pos2 += 1
				if pos2 > 2: pos2 = 0
			elif Input.is_action_just_pressed("ply_up"):
				pos2 -=1
				if pos2 < 0: pos2 = 2
			
			#menu_color_array[pos].r = float(randi() % 255)/255
			#get_node(menu_color_array[pos]).r = float(randi() % 255)/255
			#Worldconfig.playercar.menu_color_array[pos] = float(randi() % 255)/255
			
			if pos2 == 0:
				if Input.is_action_just_pressed("ply_left"): menu_color_array[pos].r = stepify(overflow(menu_color_array[pos].r+0.1,0,1),0.1)
				elif Input.is_action_just_pressed("ply_right"): menu_color_array[pos].r = stepify(overflow(menu_color_array[pos].r-0.1,0,1),0.1)
			elif pos2 == 1:
				if Input.is_action_just_pressed("ply_left"): menu_color_array[pos].g = stepify(overflow(menu_color_array[pos].g+0.1,0,1),0.1)
				elif Input.is_action_just_pressed("ply_right"): menu_color_array[pos].g = stepify(overflow(menu_color_array[pos].g-0.1,0,1),0.1)
			elif pos2 == 2:
				if Input.is_action_just_pressed("ply_left"): menu_color_array[pos].b = stepify(overflow(menu_color_array[pos].b+0.1,0,1),0.1)
				elif Input.is_action_just_pressed("ply_right"): menu_color_array[pos].b = stepify(overflow(menu_color_array[pos].b-0.1,0,1),0.1)
			
			
			if Input.is_action_just_pressed("ply_use"):
				on = 1
			elif Input.is_action_just_pressed("ply_lookleft"):
				copy = menu_color_array[pos]
			elif Input.is_action_just_pressed("ply_lookright"):
				menu_color_array[pos] = copy
			elif Input.is_action_just_pressed("ply_strafe"):
				if pos == 0: Worldconfig.playercar.color_top = menu_color_array[pos]
				elif pos == 1: Worldconfig.playercar.color_inside = menu_color_array[pos]
				elif pos == 2: Worldconfig.playercar.color_sideL = menu_color_array[pos]
				elif pos == 3: Worldconfig.playercar.color_sideR = menu_color_array[pos]
				elif pos == 4: Worldconfig.playercar.color_front = menu_color_array[pos]
				elif pos == 5: Worldconfig.playercar.color_back = menu_color_array[pos]
				elif pos == 6: Worldconfig.playercar.color_hood = menu_color_array[pos]
				elif pos == 7: Worldconfig.playercar.color_trunk = menu_color_array[pos]
				elif pos == 8: Worldconfig.playercar.color_window = menu_color_array[pos]
				elif pos == 9: Worldconfig.playercar.color_rearlight = menu_color_array[pos]
				elif pos == 10: Worldconfig.playercar.color_headlight = menu_color_array[pos]
				elif pos == 11: Worldconfig.playercar.color_wheelLB = menu_color_array[pos]
				elif pos == 12: Worldconfig.playercar.color_wheelLF = menu_color_array[pos]
				elif pos == 13: Worldconfig.playercar.color_wheelRB = menu_color_array[pos]
				elif pos == 14: Worldconfig.playercar.color_wheelRF = menu_color_array[pos]
				Worldconfig.playercar.paint_it()
				on = 1
				
				
			
		
		
		
		elif on == 1:
			if Input.is_action_just_pressed("ply_use"):
				on = 0
				Worldconfig.menu = null
			
			elif Input.is_action_just_pressed("ply_lookleft"):
				copy = menu_color_array[pos]
			elif Input.is_action_just_pressed("ply_lookright"):
				if pos == 0: Worldconfig.playercar.color_top = copy
				elif pos == 1: Worldconfig.playercar.color_inside = copy
				elif pos == 2: Worldconfig.playercar.color_sideL = copy
				elif pos == 3: Worldconfig.playercar.color_sideR = copy
				elif pos == 4: Worldconfig.playercar.color_front = copy
				elif pos == 5: Worldconfig.playercar.color_back = copy
				elif pos == 6: Worldconfig.playercar.color_hood = copy
				elif pos == 7: Worldconfig.playercar.color_trunk = copy
				elif pos == 8: Worldconfig.playercar.color_window = copy
				elif pos == 9: Worldconfig.playercar.color_rearlight = copy
				elif pos == 10: Worldconfig.playercar.color_headlight = copy
				elif pos == 11: Worldconfig.playercar.color_wheelLB = copy
				elif pos == 12: Worldconfig.playercar.color_wheelLF = copy
				elif pos == 13: Worldconfig.playercar.color_wheelRB = copy
				elif pos == 14: Worldconfig.playercar.color_wheelRF = copy
				Worldconfig.playercar.paint_it()
			
			elif Input.is_action_just_pressed("ply_strafe"):
				pos2 = 0
				on = 2
			
			
			
			if Input.is_action_just_pressed("ply_down"):
				pos += 1
				if pos > max_pos: pos = 0
			elif Input.is_action_just_pressed("ply_up"):
				pos -= 1
				if pos < 0: pos = max_pos
			
			
			for n in menu_string_array.size():
				if n == pos:
					menu_string_array[n] = menu_string_array[n].to_upper()
				else:
					menu_string_array[n] = menu_string_array[n].to_lower()
			
			
			
			menu_color_array = [Worldconfig.playercar.color_top,
			Worldconfig.playercar.color_inside,
			Worldconfig.playercar.color_sideL,
			Worldconfig.playercar.color_sideR,
			Worldconfig.playercar.color_front,
			Worldconfig.playercar.color_back,
			Worldconfig.playercar.color_hood,
			Worldconfig.playercar.color_trunk,
			Worldconfig.playercar.color_window,
			Worldconfig.playercar.color_rearlight,
			Worldconfig.playercar.color_headlight,
			Worldconfig.playercar.color_wheelLB,
			Worldconfig.playercar.color_wheelLF,
			Worldconfig.playercar.color_wheelRB,
			Worldconfig.playercar.color_wheelRF]
			
			
			string = str(
				myname,
				"Colors [",pos,"/",max_pos,"]:\n",menu_string_array,"\n\nClipboard:",copy,"\nLOOK-LEFT:Copy, LOOK-RIGHT:Paste,\nSHIFT:Select, USE:Quit")
		
		
		






func overflow(N, minn, maxx):
	while N > maxx:
		N -= range(minn, maxx).size()
	
	while N < minn:
		N += range(minn, maxx).size()
	
	return N
