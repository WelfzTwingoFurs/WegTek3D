extends KinematicBody2D
#OS.get_system_time_msecs()

var motion = Vector2()

export var angles = 120
export var draw_distance = 1000

onready var change_checker = []

func _ready():
	$Background.visible = 1
	#$View/Feet.visible = 1
	#Turn everything on
	
	$ViewArea/ViewCol.polygon = [Vector2(0,0),   Vector2(0,draw_distance*2).rotated(-deg_rad(angles/2)),   Vector2(0,draw_distance*2).rotated( deg_rad(angles/2))]
	change_checker = [$View/Feet.texture, $Background/Sky.texture, $Background/Floor.texture, feet_stretch, draw_distance, angles, OS.window_size*0, sky_stretch]
	#Checks if things changed and updates

########        ############        ####        ########        ####    ####
####    ####    ####            ####    ####    ####    ####    ####    ####
########        ########        ############    ####    ####    ############
####    ####    ####            ####    ####    ####    ####        ####
####    ####    ############    ####    ####    ########            ####

################################################################################
################################################################################
################################################################################
################################################################################
################################################################################








export var skycolor = Color8(47,0,77)
export var sky_stretch = Vector2(1,1)


export var rotate_rate = 3.0
var rotation_angle = 0


export var speed = 100
var input_dir = Vector2(0,0)
var move_dir = Vector2(0,0)


export var vbob_max = 4.0
export var vbob_speed = 0.09
var vbob = 0

export var vroll_multi = -1.5
var vroll_strafe_divi = 1 #changes if strafing



var positionZ = 0.1
#var motionZ = 0
#const GRAVITY = 1
#const JUMP = -10

var posZlookZ = 0
#Used for sky & floor position according to draw_distance

var lookingZ = 0
#View pans up and down





func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = Vector2(speed*move_dir.x, speed*move_dir.y).rotated(rotation_angle)
	$ViewArea/ViewCol.rotation_degrees = rad_deg(rotation_angle) #radian to degrees
	
	if Input.is_action_pressed("ui_up"):
		input_dir.y = 1
		move_dir.y = 1
	
	elif Input.is_action_pressed("ui_down"):
		input_dir.y = -1
		move_dir.y = -1
	
	else: #no inputs
		input_dir.y = 0
		move_dir.y = 0
	
	
	
	if Input.is_action_pressed("ui_left"):
		input_dir.x = 1
		
		if Input.is_action_pressed("ui_select"): #strafe
			move_dir.x = 1
			vroll_strafe_divi = 1
			
		else:
			vroll_strafe_divi = 1.3
			move_dir.x = 0
			
			rotation_angle -= 0.0174533 * rotate_rate #1 degree in radian
			if rotation_angle < 0:
				rotation_angle = 2*PI #360 in radian
	
	
	elif Input.is_action_pressed("ui_right"):
		input_dir.x = -1
		
		if Input.is_action_pressed("ui_select"): #strafe
			move_dir.x = -1
			vroll_strafe_divi = 1
			
		else:
			vroll_strafe_divi = 1.3
			move_dir.x = 0
			
			rotation_angle += 0.0174533 * rotate_rate #1 degree in radian
			if rotation_angle > 2*PI: #360 in radian
				rotation_angle = 0
	
	
	else: #no inputs
		input_dir.x = 0
		move_dir.x = 0
	
	
	
	if Input.is_action_pressed("bug_rotatecenter"):
		move_dir = Vector2(0,0)
		
		print(rotation_angle," = ", rad_deg(rotation_angle))
		
		
		if abs(input_dir.x) != abs(input_dir.y):
			if input_dir.y == -1: #down
				rotation_angle = 0
			
			elif input_dir.y == 1: #up
				rotation_angle = PI
			
			elif input_dir.x == 1: #left
				rotation_angle = 0.5*PI
			
			elif input_dir.x == -1: #right
				rotation_angle = 1.5*PI
			
		
		else:
			if input_dir.y == -1: #down
				if input_dir.x == 0:
					rotation_angle = 0
				elif input_dir.x == 1:
					rotation_angle = deg_rad(45)
				elif input_dir.x == -1:
					rotation_angle = deg_rad(315)
			
			elif input_dir.y == 1: #up
				if input_dir.x == 0:
					rotation_angle = PI
				elif input_dir.x == 1:
					rotation_angle = deg_rad(135)
				elif input_dir.x == -1:
					rotation_angle = deg_rad(225)
	
	
	
	############################################################################
	############################################################################
	#Z inputs & math
	
	if Input.is_action_pressed("ply_jump"):
		positionZ += 10 * rotate_rate * Engine.time_scale
	elif Input.is_action_pressed("ply_crouch"):
		positionZ -= 10 * rotate_rate * Engine.time_scale
	elif Input.is_action_pressed("ply_flycenter"):
		positionZ = lerp(positionZ, 0, 0.1)
	#print(positionZ)
	#print(lookingZ)
	if Input.is_action_pressed("ply_lookup"):
		if lookingZ < 360:
			lookingZ += rotate_rate * Engine.time_scale
	elif Input.is_action_pressed("ply_lookdown"):
		if lookingZ > -360:
			lookingZ -= rotate_rate * Engine.time_scale
	elif Input.is_action_pressed("ply_lookcenter"):
		lookingZ = lerp(lookingZ, 0, 0.1)
	
	if abs(lookingZ) > 360:
		lookingZ = 360 * sign(lookingZ)
	
	posZlookZ = OS.window_size.y*(positionZ/draw_distance/10) + OS.window_size.y*(lookingZ/100)
	#Used for sky & floor position according to draw_distance
	
	
	###   ######      ######   ###   ###   #########
	###   ###   ###   ##  ##   ###   ###      ###
	###   ###   ###   ######   ###   ###      ###
	###   ###   ###   ###      #########      ###
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	# ^^ Input, motion, rotation
	
	
	
	
	# vv Sprite effects, vbob
	########################################################################################################################################################
	########################################################################################################################################################
	if move_dir != Vector2(0,0):
		if move_dir.y == 1:
			vbob += vbob_speed
		else:
			vbob -= vbob_speed
	
	else:
		if vbob != 0:
			vbob = stepify(lerp(vbob,0,0.1),0.1)
	
	
	if vbob > vbob_max:
		vbob = -vbob_max
	elif vbob < -vbob_max:
		vbob = vbob_max
	
	##  ##  ####      ##    ####     ##    ##    ###    ###  ###  ###  ###
	##  ##  ##  ##  ##  ##  ##  ##   # ##  # #  #   #  #     #    #    #
	##  ##  ####    ##  ##  ####     ##    ##   #   #  #     ###  ###  ###
	##  ##  ##  ##  ##  ##  ##  ##   #     # #  #   #  #     #      #    #
	  ##    ####      ##    ####     #     # #   ###    ###  ###  ###  ###
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	#vbob and vroll
	$PolyContainer.position.y = abs(vbob) +OS.window_size.y*(lookingZ/100)
	$PolyContainer.rotation_degrees = lerp($PolyContainer.rotation_degrees, (-input_dir.x*vroll_multi),00.1)/vroll_strafe_divi
	$Background.rotation_degrees = $PolyContainer.rotation_degrees
	
	
	########################################################################################################################################################
	if sky_stretch.y == 1:
		$Background/Sky.rect_position.y = ($Background/Sky.rect_size.y  /OS.window_size.y) + abs(vbob) +vbob_max +posZlookZ
		
	else:
		$Background/Sky.rect_position.y = -$Background/Sky.rect_size.y + abs(vbob) +vbob_max +posZlookZ
	
	if sky_stretch.x == 1:
		$Background/Sky.rect_position.x = (-OS.window_size.x/2) - ( $ViewArea/ViewCol.rotation_degrees*(float(OS.window_size.x)/360) )
		
	else:
		$Background/Sky.rect_position.x = (-OS.window_size.x/2) - ( $ViewArea/ViewCol.rotation_degrees*(float($Background/Sky.texture.get_width())/360) ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	
	
	
	########################################################################################################################################################
	if sign($Background/Floor.position.y/OS.window_size.y) < 0:         #Floor doesn't stretch until looking down limit, it ends around when Sky is out of view
		VisualServer.set_default_clear_color($Background/Floor.modulate)# and changes the skycolor to its color when that limit is reached
	else:
		VisualServer.set_default_clear_color(skycolor)
	
	
	$Background/Floor.position.y = (OS.window_size.y) + abs(vbob) +posZlookZ
	#Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	####      ####      ####    ####      ##      ##  ####  ####  ####
	##  ##  ##          ##  ##  ##  ##  ##  ##  ##    ##    ##    ##
	####    ##  ####    ####    ####    ##  ##  ##    ####  ####  ####
	##  ##  ##    ##    ##      ##  ##  ##  ##  ##    ##      ##    ##
	####      ####      ##      ##  ##    ##      ##  ####  ####  ####
	
	
#	if lookingZ < -280: #feet when looking down, imprecise to collision shape NEEDS WERKIN
#		$View/Feet.scale.y = 1#-(OS.window_size.y/lookingZ)*2
#		#$View/Feet.position.y = (OS.window_size.y/$View/Feet.texture.get_height()) + (OS.window_size.y*(lookingZ/100))
#		$View/Feet.position.y = $PolyContainer.position.y
#
#
#
#		#lookingZ 
#		#$View/Feet.position.y
#		#$View/Feet.scale.y
#
#		#print(lookingZ,":  ",$View/Feet.position.y," ",$View/Feet.scale.y)
#
#
#
#
#
#
#		$View/Feet.visible = 1
#		$View/Feet.rotation_degrees = (-input_dir.x*vroll_strafe_divi)*$View/Feet.scale.y*2
#		#feetY = $View/Feet.position.y
#
#
#
#		if input_dir.y != 0:
#			$AnimationPlayer.play("walk")
#			$AnimationPlayer.playback_speed = input_dir.y
#
#		elif input_dir.x != 0:
#			if Input.is_action_pressed("ui_select"):
#				if input_dir.x == -1:
#					$AnimationPlayer.play("strafeR")
#				else:
#					$AnimationPlayer.play("strafeL")
#
#			else:
#				$AnimationPlayer.play("spin")
#				$AnimationPlayer.playback_speed = input_dir.x
#
#
#		else:
#			$View/Feet.frame = 0
#			$AnimationPlayer.stop()
#
#	else:
#		$View/Feet.visible = 0
#		$AnimationPlayer.stop()
	
	### ### ### ###
	##  ##  ##   #
	#   ### ###  #
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	
	
	
	if change_checker != [$View/Feet.texture, $Background/Sky.texture, $Background/Floor.texture, feet_stretch, draw_distance, angles, OS.window_size, sky_stretch]:
		recalculate()
	else:
		if !Input.is_action_pressed("bug_closeeyes"):
			BSP()
	
	
	update() #for the map

#####    #####      #####      #####  ##########   ##########  #########
##   ##  ##   ##  ##     ##  ##       ##           ###         ###
##   ##  ##   ##  ##     ##  ##       ##           ###         ###
#####    #####    ##     ##  ##       ##########   ##########  #########
##       ##   ##  ##     ##  ##       ##                  ###         ##
##       ##   ##  ##     ##  ##       ##                  ###         ##
##       ##   ##    #####      #####  ##########   ##########  #########

################################################################################
################################################################################
################################################################################
################################################################################






#		draw_line(Vector2(-abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Vector2(abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Color(1,1,1), 1)
#		draw_line(Vector2(-abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Vector2(abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Color(1,1,1), 1)
#		
#		draw_line(Vector2(-abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Vector2(-abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Color(1,1,1), 1)
#		draw_line(Vector2(abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Vector2(abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Color(1,1,1), 1)


var feet_stretch = 1

func recalculate():
	if sky_stretch.x + sky_stretch.y > 2:
		print("M I S T A K E: sky_stretch value invalid")
	if abs(map_draw) > 6:
		print("M I S T A K E: map_draw value invalid!")
	
	
	if change_checker[0] != $View/Feet.texture or change_checker[3] != feet_stretch or change_checker[6] != OS.window_size:
		if feet_stretch == 1:
			$View/Feet.scale.x = OS.window_size.x/$View/Feet.texture.get_width()*10
		else:
			$View/Feet.scale.x = $View/Feet.scale.y 
		
		if change_checker[0] != $View/Feet.texture:
			print("-      TEXTURE: Feet changed")
			change_checker[0] = $View/Feet.texture
			
		elif change_checker[3] != feet_stretch:
			print("- FEET_STRETCH: ",feet_stretch,", changed from ",change_checker[3])
			change_checker[3] = feet_stretch
			
		
	
	
	if change_checker[1] != $Background/Sky.texture or change_checker[7] != sky_stretch or change_checker[6] != OS.window_size:
		$Background/Sky.rect_size.y = $Background/Sky.texture.get_height()
		#$Background/Sky.rect_size.x = ($Background/Sky.texture.get_width()+OS.window_size.x)
		#$Background/Sky.rect_size.x = $Background/Sky.texture.get_width()*2
		
		
		if sky_stretch.y == 1:
			$Background/Sky.rect_scale.y = -(OS.window_size.y/2)/float($Background/Sky.rect_size.y) 
			$Background/Sky.flip_v = 1
		else:
			$Background/Sky.rect_scale.y = 1
			$Background/Sky.flip_v = 0
		
		
		if sky_stretch.x == 1:
			$Background/Sky.rect_size.x = $Background/Sky.texture.get_width()*2
			$Background/Sky.rect_scale.x = (OS.window_size.x/$Background/Sky.texture.get_width())
		else:
			$Background/Sky.rect_size.x = ($Background/Sky.texture.get_width()+OS.window_size.x)
			$Background/Sky.rect_scale.x = 1
		
		
		
		if change_checker[1] != $Background/Sky.texture:
			print("-      TEXTURE: Sky changed")
			change_checker[1] = $Background/Sky.texture
		elif change_checker[7] != sky_stretch:
			print("-  SKY_STRETCH: ",sky_stretch,", changed from ",change_checker[7])
			change_checker[7] = sky_stretch
		
	
	
	if change_checker[2] != $Background/Floor.texture or change_checker[6] != OS.window_size:
		$Background/Floor.scale = Vector2( (OS.window_size.x/$Background/Floor.texture.get_width())+1,    (OS.window_size.y/($Background/Floor.texture.get_height()/2))  )
		
		if change_checker[2] != $Background/Floor.texture:
			print("-      TEXTURE: Floor changed")
			change_checker[2] = $Background/Floor.texture
			
		
	
	
	if change_checker[4] != draw_distance or change_checker[5] != angles or change_checker[6] != OS.window_size:
		var midscreenFirst = OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated(-deg_rad((angles)/2)) ).angle() ))
		var midscreenLast  = OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated( deg_rad((angles)/2)) ).angle() ))
		
		$PolyContainer.scale.x = abs(midscreenFirst - midscreenLast)
		$PolyContainer.scale.y = 10#(OS.window_size.x/midscreenFirst) - (OS.window_size.x/midscreenLast)
		
		
		if change_checker[4] != draw_distance or change_checker[5] != angles:
			#$ViewArea/ViewCol.polygon = [Vector2(0,0),Vector2(0,draw_distance).rotated(-deg_rad(angles/2)),Vector2(0,draw_distance).rotated( deg_rad(angles/2))]
			$ViewArea/ViewCol.polygon = [Vector2(0,0),Vector2(0,draw_distance*2).rotated(-deg_rad(angles/2)),Vector2(0,draw_distance*2).rotated( deg_rad(angles/2))]
			
			if change_checker[4] != draw_distance:
				print("-DRAW DISTANCE: ",draw_distance,", changed from ",change_checker[4])
				change_checker[4] = draw_distance
				
			elif change_checker[5] != angles:
				print("- ANGLES (FOV): ",angles,", changed from ",change_checker[5])
				change_checker[5] = angles
		
		
		elif change_checker[6] != OS.window_size:
			print("-   RESOLUTION: ",OS.window_size,", changed from ",change_checker[6])
			change_checker[6] = OS.window_size
		
	



####     ######           ####   ######   ####     ######   ##   ######
##  ##   ##               ##     ##  ##   ##  ##   ##            ##
##  ##   ##               ##     ##  ##   ##  ##   ##            ##
####     ####      ###    ##     ##  ##   ##  ##   ####     ##   ##  ##
##  ##   ##               ##     ##  ##   ##  ##   ##       ##   ##  ##
##  ##   ##               ##     ##  ##   ##  ##   ##       ##   ##  ##
##  ##   ######           ####   ######   ##  ##   ##       ##   ######

################################################################################
################################################################################
################################################################################
################################################################################












##############################################################################################################################################################################################
var polys = []
var new_container

var rot_plus90
var rot_minus90

var midscreen = 0

func BSP():
	for n in array_walls.size():
		var new_poly = $PolyContainer/Poly0.duplicate()
		
		if n == 0:
			if (weakref(new_container).get_ref()):
				new_container.queue_free()
				
			new_container = $PolyContainer.duplicate()
			add_child((new_container))
			
			midscreen = (Vector2(0,draw_distance).rotated(rotation_angle)).angle()
			
			rot_plus90  = rad_overflow(rotation_angle+(PI/2))
			rot_minus90 = rad_overflow(rotation_angle-(PI/2))
		
		
		
		var array_polygon = []
		
		for m in array_walls[n].points.size():
			#var rot_plus90  = rad_overflow(rotation_angle+(PI/2))
			#var rot_minus90 = rad_overflow(rotation_angle-(PI/2))
			var rot_object   = rad_overflow((array_walls[n].points[m]-position).angle()-PI/2)
			
			
			#stretching fix conditions
			if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object < rot_minus90 or rot_object > rot_plus90))   or   (rot_object < rot_minus90 && rot_object > rot_plus90):
				#var rot_object   = rad_overflow((array_walls[n].points[m]-position).angle()-PI/2)
				var rot_object_plus  = rad_overflow((array_walls[n].points[ array_looping(m+1, array_walls[n].points.size()) ]-position).angle()-PI/2)
				var rot_object_minus = rad_overflow((array_walls[n].points[ array_looping(m-1, array_walls[n].points.size()) ]-position).angle()-PI/2)
				var activator = Vector2(0,0)
				
				
				if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object_plus < rot_minus90 or rot_object_plus > rot_plus90))   or   (rot_object_plus < rot_minus90 && rot_object_plus > rot_plus90):
					activator.x = 1
				
				if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object_minus < rot_minus90 or rot_object_minus > rot_plus90))   or   (rot_object_minus < rot_minus90 && rot_object_minus > rot_plus90):
					activator.y = 1
				
				
				if (activator.x == 1) && (activator.y == 1):  #both neighbours bad, delete
					break
				
				else:
					var limitPlus  = position+(Vector2(0,100).rotated(rotation_angle+PI/2))
					var limitMinus = position+(Vector2(0,100).rotated(rotation_angle-PI/2))
					var point1 = array_walls[n].points[m]
					var point2
					var new_position
					
					
					
					if (activator.x == 0) && (activator.y == 1):#minus neighbour bad, go with plus neighbour
						point2 = array_walls[n].points[ array_looping(m+1, array_walls[n].points.size()) ]
					
					else:#if (activator.x == 1) && (activator.y == 0):#plus neighbour bad, go with minus neighbour
					#####if (activator.x == 0) && (activator.y) == 0:#no bad neighbours, make 2 new points
						point2 = array_walls[n].points[ array_looping(m-1, array_walls[n].points.size()) ]
					
					
					new_position = new_position(point1, point2, limitPlus, limitMinus, (point1.x - point2.x)*(limitPlus.y - limitMinus.y) - (point1.y - point2.y)*(limitPlus.x - limitMinus.x))  +  Vector2(0,1).rotated(rotation_angle)
					var holyshit = (new_position-position).angle() - midscreen
					var lineH = (OS.window_size.y / (sqrt(pow((new_position.x - position.x), 2) + pow((new_position.y - position.y), 2))))   /  cos(holyshit) #Logic from other raycasters
					
					array_polygon.append(Vector2(tan(holyshit), ((positionZ/100)*lineH)-lineH*array_walls[n].heights[m]))
					
					
					if (activator.x == 0) && (activator.y) == 0:#no bad neighbours, make 2 new points
						var point3 = array_walls[n].points[ array_looping(m+1, array_walls[n].points.size()) ]
						
						new_position = new_position(point1,point3,limitPlus,limitMinus,(point1.x - point3.x)*(limitPlus.y - limitMinus.y) - (point1.y - point3.y)*(limitPlus.x - limitMinus.x))  +  Vector2(0,1).rotated(rotation_angle)
						holyshit = (new_position-position).angle() - midscreen
						lineH = (OS.window_size.y / (sqrt(pow((new_position.x - position.x), 2) + pow((new_position.y - position.y), 2))))   /  cos(holyshit) #Logic from other raycasters
						
						array_polygon.append(Vector2(tan(holyshit), ((positionZ/100)*lineH)-lineH*array_walls[n].heights[m]))
						
						#From what I've checked the conditions are correct, the math is correct...
						#what is wrong??
			
			
			
			
			else:
				var holyshit = (array_walls[n].points[m]-position).angle() - midscreen
				var xkusu = tan(holyshit)
				
				var distance = sqrt(pow((array_walls[n].points[m].x - position.x), 2) + pow((array_walls[n].points[m].y - position.y), 2)) #Logic from other raycasters
				var lineH = (OS.window_size.y / distance)   /  cos(holyshit)
				
				array_polygon.append(Vector2(xkusu,((positionZ/100)*lineH)-lineH*array_walls[n].heights[m])) #we may need to change append or vertexes will get out of order
				#Polygon over
			
			
			
			if m == array_walls[n].points.size()-1:#The fucking end so fucking far
				
				#var new_poly = $PolyContainer/Poly0.duplicate()
				new_poly.polygon.resize(array_walls[n].points.size())
				new_poly.set_polygon( PoolVector2Array(array_polygon) )
				
				new_container.add_child((new_poly))






#determinante = (array_walls[n].points[array_stretched[0]].x - array_walls[n].points[array_stretched[0]-1].x)  *  ((Vector2(0,9999).rotated(rotation_angle+PI/2)).y - (Vector2(0,9999).rotated(rotation_angle-PI/2)).y)   -   (array_walls[n].points[array_stretched[0]].y - array_walls[n].points[array_stretched[0]-1].y)  *  ((Vector2(0,9999).rotated(rotation_angle+PI/2)).x - (Vector2(0,9999).rotated(rotation_angle-PI/2)).x)
func new_position(point1,point2,limitPlus,limitMinus,det): #This math works until here, I confirmed, so the problem lies ahead
	var new_position
	
	if det != 0:
		new_position = Vector2(
		((point1.x*point2.y - point1.y*point2.x) * (limitPlus.x-limitMinus.x)  -  (point1.x-point2.x) * (limitPlus.x*limitMinus.y - limitPlus.y*limitMinus.x))/det,
		((point1.x*point2.y - point1.y*point2.x) * (limitPlus.y-limitMinus.y)  -  (point1.y-point2.y) * (limitPlus.x*limitMinus.y - limitPlus.y*limitMinus.x))/det)
	else:
		new_position = Vector2(0,0)
	
	return(new_position)


#func array_looping(to_check, array_size):#This is causing issues big time BIG time
#	#array_size -= 1
#
#	if to_check < 0:
#		to_check += array_size
#
#	#if between 0 & array_size OK!!
#
#	elif to_check == array_size:
#	#elif to_check > array_size:
#		to_check -= array_size 
#
#	#elif to_check > array_size:
#	#	to_check -=  array_size-(to_check-array_size)
#
#	else:
#		print("uh? ",to_check," ",array_size)
#
#	return(to_check)

func array_looping(to_check, array_size):
	array_size -= 1
	
	if to_check < 0:
		to_check += array_size
	
	if to_check > array_size:
		to_check -= array_size
	
	
	if (to_check < 0) or (to_check > array_size):
		array_size += 1
		to_check = array_looping(to_check, array_size)
	
	return(to_check)














var array_walls = []

func _on_ViewArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("polywall"):
		if !array_walls.has(body):
			array_walls.push_back(body)

func _on_ViewArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("polywall"):
		if array_walls.has(body):
			array_walls.erase(body)
			
			if array_walls.size() == 0 && (weakref(new_container).get_ref()):
				new_container.queue_free()



#var array_objects = []
#
#func _on_ViewArea_body_entered(body):
#	if body.is_in_group("object"):
#		if !array_objects.has(body):
#			array_objects.push_back(body)
#			print(body)
#
#
#func _on_ViewArea_body_exited(body):
#	if body.is_in_group("object"):
#		if !array_objects.has(body):
#			array_objects.push_back(body)
#			print(body)


########        ########            ####        ####            ####  
########        ########            ####        ####            ####
####    ####    ####    ####    ####    ####    ####    ####    ####  
####    ####    ####    ####    ####    ####    ####    ####    ####  
####    ####    ########        ############    ####    ####    ####  
####    ####    ########        ############    ####    ####    ####  
########        ####    ####    ####    ####        ####    ####    
########        ####    ####    ####    ####        ####    ####      

################################################################################
################################################################################
################################################################################
################################################################################















export var map_draw = 2

func _draw():
	if Worldconfig.zoom < 1:
		#draw_line(Vector2(-abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Vector2(abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Color(1,1,1), 1)
		draw_line(Vector2(-abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Vector2(abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Color(1,1,1), 1)
		draw_line(Vector2(-abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Vector2(abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Color(1,1,1), 1)
		
		draw_line(Vector2(-abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Vector2(-abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Color(1,1,1), 1)
		draw_line(Vector2(abs(get_viewport().size.x)/2, abs(get_viewport().size.y)/2), Vector2(abs(get_viewport().size.x)/2, -abs(get_viewport().size.y)/2), Color(1,1,1), 1)
		
	
	
	if Input.is_action_pressed("ui_accept"): #Must always update otherwise it doesn't dissapear
		var shine1 = Color((randi() % 2),(randi() % 2),(randi() % 2))
		var orange = Color(1, 0.5, 0)
		
		draw_line(Vector2(0,0), Vector2(0,draw_distance).rotated(rotation_angle), Color(1,1,1), 1)
		if sign(map_draw) == 1:
			draw_line(Vector2(0,0), Vector2(0,draw_distance*2).rotated(rotation_angle-deg_rad(angles/2)), shine1, 1)
			draw_line(Vector2(0,0), Vector2(0,draw_distance*2).rotated(rotation_angle+deg_rad(angles/2)), shine1, 1)
			draw_line(Vector2(0,draw_distance*2).rotated(rotation_angle-deg_rad(angles/2)), Vector2(0,draw_distance*2).rotated(rotation_angle+deg_rad(angles/2)), shine1, 1)
			
			#draw_line(Vector2(0,0), Vector2(0,9999).rotated(rotation_angle+PI/2), Color(1,0,0, 0.4), 1)
			#draw_line(Vector2(0,0), Vector2(0,9999).rotated(rotation_angle-PI/2), Color(1,0,0, 0.4), 1)
			draw_line(Vector2(0,9999).rotated(rotation_angle+PI/2), Vector2(0,9999).rotated(rotation_angle-PI/2), Color(0.5, 0, 1), 1)
		
		
		
		
		
		if abs(map_draw) == 1: #walls in area
			for n in array_walls.size():
				for m in array_walls[n].points.size():
					if m < array_walls[n].points.size()-1:
						draw_line(array_walls[n].points[m]-position, array_walls[n].points[m+1]-position, orange, 1)
					else:
						draw_line(array_walls[n].points[array_walls[n].points.size()-1]-position, array_walls[n].points[0]-position, orange, 1)
		
		
		
		elif abs(map_draw) == 2: #all walls
			var targets_in_scene = []
			targets_in_scene = get_tree().get_nodes_in_group("polywall") #Who is spawned
			
			if targets_in_scene.size() != 0: #If anyone at all
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
					
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line(targets_in_scene[n].points[m]-position, targets_in_scene[n].points[m+1]-position, orange, 1)
								else:
									draw_line(targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position, targets_in_scene[n].points[0]-position, orange, 1)
						targets_in_scene = []
		
		
		
		
		
		
		
		
		elif abs(map_draw) == 3: #3D walls in area
			for n in array_walls.size():
				for m in array_walls[n].points.size():
					var posZ = positionZ/200
					
					if m < array_walls[n].points.size()-1:
						draw_line(((array_walls[n].heights[m]+1) / posZ)*(array_walls[n].points[m]-position), ((array_walls[n].heights[m+1]+1) / posZ)*(array_walls[n].points[m+1]-position), orange, 1)
					else:
						draw_line(((array_walls[n].heights[array_walls[n].points.size()-1]+1) / posZ)*(array_walls[n].points[array_walls[n].points.size()-1]-position), ((array_walls[n].heights[0]+1) / posZ)*(array_walls[n].points[0]-position), orange, 1)
			
		
		elif abs(map_draw) == 4: #all 3D walls
			var targets_in_scene = []
			targets_in_scene = get_tree().get_nodes_in_group("polywall") #Who is spawned
			
			if targets_in_scene.size() != 0: #If anyone at all
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
						var posZ = positionZ/200
						
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line(((targets_in_scene[n].heights[ m                                 ]+1) / posZ) * (targets_in_scene[n].points[ m                                 ]-position),  ((targets_in_scene[n].heights[m+1]+1) / posZ)*(targets_in_scene[n].points[m+1]-position), orange, 1)
									
								else:
									draw_line(((targets_in_scene[n].heights[targets_in_scene[n].points.size()-1]+1) / posZ) * (targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position),  ((targets_in_scene[n].heights[ 0 ]+1) / posZ)*(targets_in_scene[n].points[ 0 ]-position), orange, 1)
									
						
						targets_in_scene = []
		
		
		
		
		elif abs(map_draw) == 5: #3D walls in area 2
			for n in array_walls.size():
				for m in array_walls[n].points.size():
					var posZ = positionZ/200
					
					if m < array_walls[n].points.size()-1:
						draw_line((1+array_walls[n].heights[ m                            ] * posZ/10) * (array_walls[n].points[ m                            ]-position),  (1+array_walls[n].heights[m+1] * posZ/10)*(array_walls[n].points[m+1]-position), orange, 1)
						
					else:
						draw_line((1+array_walls[n].heights[array_walls[n].points.size()-1] * posZ/10) * (array_walls[n].points[array_walls[n].points.size()-1]-position),  (1+array_walls[n].heights[ 0 ] * posZ/10)*(array_walls[n].points[ 0 ]-position), orange, 1)
						
		
		elif abs(map_draw) == 6: #all 3D walls 2
			var targets_in_scene = []
			targets_in_scene = get_tree().get_nodes_in_group("polywall") #Who is spawned
			
			if targets_in_scene.size() != 0: #If anyone at all
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
						
						var posZ = positionZ/200
						
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line((1+targets_in_scene[n].heights[ m                                 ] * posZ/10) * (targets_in_scene[n].points[ m                                 ]-position),  (1+targets_in_scene[n].heights[m+1] * posZ/10)*(targets_in_scene[n].points[m+1]-position), orange, 1)
									
								
								else:
									draw_line((1+targets_in_scene[n].heights[targets_in_scene[n].points.size()-1] * posZ/10) * (targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position),  (1+targets_in_scene[n].heights[ 0 ] * posZ/10)*(targets_in_scene[n].points[ 0 ]-position), orange, 1)
									
						targets_in_scene = []
		
		
		print(position)


	####    ####                ####            ############
####    ####    ####        ####    ####        ####        ####
####    ####    ####        ####    ####        ####        ####
####            ####        ############        ############
####            ####        ####    ####        ####
####            ####        ####    ####        ####

################################################################################
################################################################################
################################################################################
################################################################################




#GRAVITY AND JUMPING FOR WHEN WE LATER NEED IT
#	if Input.is_action_just_pressed("ply_jump"):
#		motionZ += JUMP
#	positionZ += motionZ
#	if positionZ < 0:
#		if Input.is_action_pressed("ply_jump"):
#			motionZ += (GRAVITY-0.5)
#		else:
#			motionZ += GRAVITY # 1
#	elif motionZ > 0: #If goes over, correct to 0
#		positionZ = 0
#		motionZ = 0



#WORLD LOOKING ROUND RENDER
#sprites[n].position.y = texture_cellsize/(-positionZ*lineH)


#OLD VARIABLE I DON'T KNOW IF EVEN WORKED
#			var dir = Vector2( sign(rays[n].get_collision_point().x - position.x), sign(rays[n].get_collision_point().y - position.y) )
#			#   up = -1,-1.   left = -1, 1.   down =  1, 1.   right =  1,-1.
#			#right     -ok
#			#up/down   -fuzzy
#			#left/down -flipped but not always?


#HOW TO GET POSITION AHEAD OF RAYCAST
#					var Numba = 0#angles/2
#					
#					draw_line(Vector2(0,0), rays[Numba].get_collision_point() - position, Color(1,1,0), 2)
#					
#					
#					var cum = deg_rad($RayContainer.rotation_degrees + rays[Numba].rotation_degrees)
#					
#					draw_line(rays[Numba].get_collision_point() - position,
#							 (rays[Numba].get_collision_point() - position) + Vector2(0,10).rotated(  cum  ),
#					Color(1,0,0), 3)
					# This was gonna be used for a fix_cell() idea when that was still around, worth keeping nonetheless


func rad_deg(N):
	N *= 180/PI
	return N

func deg_rad(N):
	N *= PI/180
	return N


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
