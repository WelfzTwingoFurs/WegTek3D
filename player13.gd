extends KinematicBody2D
#OS.get_system_time_msecs()

var motion = Vector2()

export var angles = 120
export var draw_distance = 1000

onready var change_checker = []

func _ready():
	Worldconfig.player = self
	Worldconfig.Camera2D = $Camera2D
	
	$Background.visible = 1
	#$View/Feet.visible = 1
	#Turn everything on
	
	$ViewArea/ViewCol.polygon = [Vector2(0,0),   Vector2(0,draw_distance*2).rotated(-deg_rad(angles/2)),   Vector2(0,draw_distance*2).rotated( deg_rad(angles/2))]
	change_checker = [$View/Feet.texture, $Background/Sky.texture, $Background/Floor.texture, 0, draw_distance, angles, OS.window_size*0, sky_stretch]
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
export var min_Z = 0

export var rotate_rate = 3.0
var rotation_angle = 0.000001


export var speed = 100
var input_dir = Vector2(0,0)
var move_dir = Vector3(0,0,0)


export var vbob_max = 4.0
export var vbob_speed = 0.09
var vbob = 0

export var vroll_multi = -1.5
var vroll_strafe_divi = 1 #changes if strafing



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
		move_dir = Vector3(0,0,0)
		
		#print(rotation_angle," = ", rad_deg(rotation_angle))
		
		
		if abs(input_dir.x) != abs(input_dir.y):
			if input_dir.y == -1: #down
				rotation_angle = 0 - 0.000001
			
			elif input_dir.y == 1: #up
				rotation_angle = PI - 0.000001
			
			elif input_dir.x == 1: #left
				rotation_angle = 0.5*PI - 0.000001
			
			elif input_dir.x == -1: #right
				rotation_angle = 1.5*PI - 0.000001
			
		
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
	
	if Input.is_action_pressed("ply_lookup"): #3.6 won't cut it with the new Y-FOV stretching!
		if lookingZ < $PolyContainer.scale.y*10:
			lookingZ += rotate_rate*0.01 #* Engine.time_scale
	elif Input.is_action_pressed("ply_lookdown"):
		if lookingZ > -$PolyContainer.scale.y*10:
			lookingZ -= rotate_rate*0.01 #* Engine.time_scale
	elif Input.is_action_pressed("ply_lookcenter"):
		lookingZ = lerp(lookingZ, 0, 0.1)
	
	if abs(lookingZ) > $PolyContainer.scale.y*10:# don't overflow
		lookingZ = ($PolyContainer.scale.y*10) * sign(lookingZ)
	
	#posZlookZ = OS.window_size.y*(positionZ/draw_distance/10) + OS.window_size.y*lookingZ
	posZlookZ = ( (OS.window_size.y*(positionZ/draw_distance/10)) * ($PolyContainer.scale.y*10) )  +  OS.window_size.y*lookingZ
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
	if move_dir != Vector3(0,0,0):
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
	#to_global($Camera2D.position).y = abs(vbob)
	
	$PolyContainer.position.y = OS.window_size.y*lookingZ + abs(vbob)
	$PolyContainer.rotation_degrees = lerp($PolyContainer.rotation_degrees, (-input_dir.x*vroll_multi),00.1)/vroll_strafe_divi
	$Background.rotation_degrees = $PolyContainer.rotation_degrees
	
	
	########################################################################################################################################################
	if sky_stretch.y > 0:
		$Background/Sky.rect_position.y = ($Background/Sky.rect_size.y/OS.window_size.y) +vbob_max +posZlookZ + abs(vbob)
		
	else:
		$Background/Sky.rect_position.y = -$Background/Sky.rect_size.y +vbob_max +posZlookZ + abs(vbob)
	
	if sky_stretch.x > 0:
		$Background/Sky.rect_position.x = (-OS.window_size.x/2) - ($ViewArea/ViewCol.rotation_degrees*(float(OS.window_size.x)/360))
		
	else:
		$Background/Sky.rect_position.x = (-OS.window_size.x/2) - ( $ViewArea/ViewCol.rotation_degrees*(float($Background/Sky.texture.get_width())/360) ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	
	
	
	########################################################################################################################################################
	if sign($Background/Floor.position.y/OS.window_size.y) < 0:         #Floor doesn't stretch until looking down limit, it ends around when Sky is out of view
		VisualServer.set_default_clear_color($Background/Floor.modulate)# and changes the skycolor to its color when that limit is reached
	else:
		VisualServer.set_default_clear_color(skycolor)
	
	
	$Background/Floor.position.y = OS.window_size.y+posZlookZ + abs(vbob)
	#Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	####      ####      ####    ####      ##      ##  ####  ####  ####
	##  ##  ##          ##  ##  ##  ##  ##  ##  ##    ##    ##    ##
	####    ##  ####    ####    ####    ##  ##  ##    ####  ####  ####
	##  ##  ##    ##    ##      ##  ##  ##  ##  ##    ##      ##    ##
	####      ####      ##      ##  ##    ##      ##  ####  ####  ####
	
	
	var C = float(1)
	if darkness != 0: C /= darkness
	$View.modulate = Color(C,C,C)
	
	if lookingZ < 0: #feet when looking down, imprecise to collision shape NEEDS WERKIN
		#lookingZ = 0                         == 0%
		#lookingZ = $PolyContainer.scale.y*10 == 100%
		var percent = -(lookingZ/$PolyContainer.scale.y*10)/100
		$View/Feet.scale.y = OS.window_size.y/$View/Feet.texture.get_height() * percent
		$View/Feet.position.y = ((get_viewport().size.y/2) - (get_viewport().size.y/2)*percent) + (1-percent)*100# + $PolyContainer.position.y - $PolyContainer.scale.y*10
		#print($View/Feet.modulate)
		
		$View/Feet.visible = 1
		#$View/Feet.rotation_degrees = -input_dir.x*vroll_strafe_divi*2
		#feetY = $View/Feet.position.y
		
		if on_floor == true:
			if input_dir.y != 0:
				$View/AniPlayFeet.play("walk")
				$View/AniPlayFeet.play("walk")
				$View/AniPlayFeet.playback_speed = input_dir.y

			elif input_dir.x != 0:
				if Input.is_action_pressed("ui_select"):
					if input_dir.x == -1:
						$View/AniPlayFeet.play("strafeR")
					else:
						$View/AniPlayFeet.play("strafeL")

				else:
					$View/AniPlayFeet.play("spin")
					$View/AniPlayFeet.playback_speed = input_dir.x


			else:
				$View/Feet.frame = 0
				$View/AniPlayFeet.stop()
		else:
			$View/AniPlayFeet.stop()
			if move_dir.z == 1:
				$View/Feet.frame = 6
			else:
				$View/Feet.frame = 1
		
	else:
		$View/Feet.visible = 0
		$View/AniPlayFeet.stop()
	
	### ### ### ###
	#   #   #    #
	##  ##  ##   #
	#   #   #    #
	#   ### ###  #
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	
	
	
	
	if change_checker != [$View/Feet.texture, $Background/Sky.texture, $Background/Floor.texture, 0, draw_distance, angles, OS.window_size, sky_stretch]:
		recalculate()
	else:
		if !Input.is_action_pressed("bug_closeeyes"):
			render()
	
	
	update() #for the map
	
	if motionZ < 0:
		move_dir.z = -1
	elif motionZ > 0:
		move_dir.z = 1
	elif motionZ == 0:
		move_dir.z = 0
	
	
	
	
#	if Input.is_action_pressed("ply_flycenter"):
#		motionZ = 0
#		positionZ = lerp(positionZ, 0, 0.1)
	
	#if col_floors.size() != 0:
	if Input.is_action_just_pressed("ply_noclip"):
		noclip = !noclip
		$Col.disabled = !$Col.disabled
		on_floor = false
	
	if !noclip:
		collide()
		
		if on_floor == true:
			motionZ = 0
			if Input.is_action_pressed("ply_jump"):
				motionZ += JUMP
				on_floor = false
		
		else:
			if (col_floors.size() == 0 && positionZ <= min_Z):
				on_floor = true
				motionZ = 0
			elif positionZ > min_Z:
				motionZ -= GRAVITY
			else:
				on_floor = true
				motionZ = 0
		
		positionZ += motionZ
	
	#elif (col_floors.size() == 0 && positionZ <= 0):
	#	motionZ = 0
	#	on_floor = true
	
	else:
		motionZ = 0
		if Input.is_action_pressed("ply_jump"):
			positionZ += 1 * rotate_rate * Engine.time_scale
			move_dir.z = 1
		elif Input.is_action_pressed("ply_crouch"):
			positionZ -= 1 * rotate_rate * Engine.time_scale
			move_dir.z = -1
		elif Input.is_action_pressed("ply_flycenter"):
			positionZ = lerp(positionZ, 0-ply_height, 0.1)
		else:
			move_dir.z = 0
	#print(positionZ)
	#print(lookingZ)
	
	############################################################################
	
	if Input.is_action_just_pressed("ply_wpn_next"):
		guninv += 1
		if guninv > 2: guninv = 0
		gunswitch()
	elif Input.is_action_just_pressed("ply_wpn_previous"):
		guninv -= 1
		if guninv < 0: guninv = 2
		gunswitch()
	
	if Input.is_action_pressed("ply_wpn_fire1"):
		gunfire(false)
	elif Input.is_action_pressed("ply_wpn_fire2"):
		gunfire(true)
	
	if Input.is_action_just_released("ply_wpn_fire1"):
		gunstop(false)
	if Input.is_action_just_released("ply_wpn_fire2"):
		gunstop(true)
	
	if Worldconfig.zoom < 2:
		$View/Hand.position.y = (get_viewport().size.y/2) - (($View/Hand.texture.get_size().y/$View/Hand.vframes)*gunscale)/2
		$View/Hand.position.x = (get_viewport().size.x/2) - (($View/Hand.texture.get_size().x/$View/Hand.hframes)*gunscale)/2
		$View/Hand.scale = Vector2(gunscale,gunscale)
	
	# #  #  ##  ##
	# # # # # # # #
	### ### # # # #
	# # # # # # # #
	# # # # # # ##

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

var guninv = 0
export var gunscale = 3

func gunswitch():
	print(guninv)
	if guninv == 0:
		$View/Hand.visible = 0
	else:
		$View/Hand.visible = 1
	
	if guninv == 1:
		$View/Hand.texture = load("res://assets/weapon handgun.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 2
	elif guninv == 2:
		$View/Hand.texture = load("res://assets/weapon flamethrower.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 7
	

func gunfire(alt):
	if guninv == 1:
		$View/AniPlayHand.play("hand-fire")
	
	elif guninv == 2:
		if !alt && Input.is_action_just_pressed("ply_wpn_fire1"):
			if $View/AniPlayHand.current_animation == "flame-no":
				$View/AniPlayHand.play("flame-fire")
			else:
				$View/AniPlayHand.play("flame-start")
		elif alt:
			if $View/AniPlayHand.current_animation == "flame-start" or $View/AniPlayHand.current_animation == "flame-fire":
				$View/AniPlayHand.play("flame-fire")
			else:
				$View/AniPlayHand.play("flame-no")
				
			

func gunstop(alt):
	if guninv == 2:
		if alt && $View/AniPlayHand.current_animation == "flame-fire":
			$View/AniPlayHand.play("flame-end")
		elif $View/AniPlayHand.current_animation == "flame-no":
			$View/Hand.frame = 0









################################################################################
var motionZ = 0
var positionZ = 0
#var motionZ = 0
#const GRAVITY = 1


var on_floor = false
var col_floors = []
var col_walls = []

export(float) var GRAVITY = 0.5
export(float) var JUMP = 10
export var ply_height = 45

var noclip = false

var darkness = 1

func collide():
	for n in col_walls.size():
		#darkness = col_floors[n].darkness
		
		if col_walls[n].flag_2height:
			var heightsBT = Vector2(-1,1)
			
			if col_walls[n].heights[1] < col_walls[n].heights[2]:
				heightsBT.x = col_walls[n].heights[1]
				heightsBT.y = col_walls[n].heights[2]
			else:
				heightsBT.x = col_walls[n].heights[2]
				heightsBT.y = col_walls[n].heights[1]
			
			#pé < baixo, cabeça > baixo
			#pé > baixo, cabeça < topo
			#pé < topo, cabeça > topo
			if (positionZ <= heightsBT.x && positionZ+ply_height >= heightsBT.x) or (positionZ >= heightsBT.x && positionZ+ply_height <= heightsBT.y) or (positionZ < heightsBT.y && positionZ+ply_height >= heightsBT.y): 
				# pé < topo, cabeça > topo, pé - topo = <ply_height
				if col_walls[n].jumpover && (positionZ < heightsBT.y && positionZ+ply_height > heightsBT.y) && (positionZ - heightsBT.y < ply_height/2):
					positionZ = heightsBT.y
					on_floor = true
				
				elif col_walls[n].jumpover && (positionZ < heightsBT.x && positionZ+ply_height > heightsBT.x) && ((positionZ+ply_height) - heightsBT.x < ply_height/2):
					positionZ = heightsBT.x - ply_height -1
					on_floor = false
				
				else:
					remove_collision_exception_with(col_walls[n])
			
			else:
				add_collision_exception_with(col_walls[n])
	
	for n in col_floors.size():
		darkness = col_floors[n].darkness
		
		if col_floors[n].flag_1height:
			col_proccess(n,0)
		
		else: #sometimes we gotta process a fuckin slope
			#var distances = []
			var ID = Vector2(0,0)
			
			var first = INF
			
			for m in col_floors[n].points.size():
				var distance =  sqrt(pow((col_floors[n].points[m].x - position.x), 2) + pow((col_floors[n].points[m].y - position.y), 2) + pow((col_floors[n].heights[m] - positionZ), 2))
				if distance < first:
					first = distance
					ID.x = m
			
			var second = INF
			
			for m in col_floors[n].points.size():
				var distance =  sqrt(pow((col_floors[n].points[m].x - position.x), 2) + pow((col_floors[n].points[m].y - position.y), 2) + pow((col_floors[n].heights[m] - positionZ), 2))
				if distance > first && distance < second:
					second = distance
					ID.y = m
			
			
			if on_floor == true: positionZ = col_floors[n].heights[ID.x]
			col_proccess(n,ID.x)
#			print(ID)
#			#positionZ = col_floors[n].heights[ID.x]
#			var first_second = sqrt(pow((col_floors[n].points[ID.x].x - col_floors[n].points[ID.y].x), 2) + pow((col_floors[n].points[ID.x].y - col_floors[n].points[ID.y].y), 2) + pow((col_floors[n].heights[ID.x] - col_floors[n].heights[ID.y]), 2))
#			#var first_second = sqrt(pow((col_floors[n].heights[ID.x] - col_floors[n].heights[ID.y]), 2))
#			#(me to closest distance) = 0%, (first to second distance)=100%, (me to second distance) = X%
#			#heights[ID.x]=0%, heights[ID.y]=100%
#			#positionZ = X% of heights[ID.y]-heights[ID.x]
#			#col_proccess(n,closest)
#			#first = sqrt(pow((positionZ - col_floors[n].heights[ID.x]), 2))
#			#second = sqrt(pow((positionZ - col_floors[n].heights[ID.y]), 2))
#
#			var percent
#			if col_floors[n].heights[ID.x] == col_floors[n].heights[ID.y]:
#				positionZ = col_floors[n].heights[ID.x]
#			elif col_floors[n].heights[ID.x] > col_floors[n].heights[ID.y]:
#				percent = second/(first_second) #+ 0.5
#				positionZ = col_floors[n].heights[ID.x]*percent
#				print("A")
#			else:
#				percent = first/(first_second)# + 0.5
#				positionZ = (col_floors[n].heights[ID.x]/percent) -col_floors[n].heights[ID.x]
#				print("b")
			
			
			#print(percent)



func col_proccess(n,numba):
	if col_floors[n].absolute == -1:
		if positionZ > col_floors[n].heights[numba]-1:
			positionZ = col_floors[n].heights[numba] - ply_height
			on_floor = false
	elif col_floors[n].absolute == 1:
		if positionZ < col_floors[n].heights[numba]-ply_height:
			positionZ = col_floors[n].heights[numba]
			on_floor = true
	
	
	if move_dir.z == -1:
		if (positionZ < col_floors[n].heights[numba]) && (positionZ+ply_height > col_floors[n].heights[numba]):
			positionZ = col_floors[n].heights[numba]# + ply_height
			
			on_floor = true 
			if motionZ < 0:
				motionZ = 0
				
	
	if move_dir.z == 1:
		if (positionZ < col_floors[n].heights[numba]) && (positionZ+ply_height > col_floors[n].heights[numba]):
			positionZ = col_floors[n].heights[numba] - ply_height
			
			on_floor = false
			if motionZ > 0:
				motionZ = 0











func _on_ColArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		if !col_floors.has(body):
			if (col_floors.size() == 0) && (body.flag_1height) && (on_floor == true) && (body.heights[0] < positionZ): on_floor = false
			
			col_floors.push_back(body)
			
			
	elif body.is_in_group("wall"):
		if !col_walls.has(body):
			col_walls.push_back(body)

func _on_ColArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		on_floor = false
		if col_floors.has(body):
			col_floors.erase(body)
			
			if (col_floors.size() == 0) && (positionZ <= min_Z):
				positionZ = min_Z
			
	
	if body.is_in_group("wall"):
		if col_walls.has(body):
			col_walls.erase(body)

######    #######    ###      ###      ###   ######      ######
###      ###   ###   ###      ###            ###   ##    ###
###      ###   ###   ###      ###      ###   ###   ###   #####
###      ###   ###   ###      ###      ###   ###   ##    ###
######    #######    ######   ######   ###   ######      ######

################################################################################
################################################################################
################################################################################
################################################################################











################################################################################

#var feet_stretch = 1

func recalculate():
	if change_checker[0] != $View/Feet.texture or change_checker[6] != OS.window_size:
		$View/Feet.scale.x = OS.window_size.x/$View/Feet.texture.get_width()*10
		
		if change_checker[0] != $View/Feet.texture:
			print("-      TEXTURE: Feet changed")
			change_checker[0] = $View/Feet.texture
			
		
	
	
	if change_checker[1] != $Background/Sky.texture or change_checker[7] != sky_stretch or change_checker[6] != OS.window_size:
		$Background/Sky.rect_size.y = $Background/Sky.texture.get_height()
		#$Background/Sky.rect_size.x = ($Background/Sky.texture.get_width()+OS.window_size.x)
		#$Background/Sky.rect_size.x = $Background/Sky.texture.get_width()*2
		
		
		if sky_stretch.y > 0:
			$Background/Sky.rect_scale.y = ( -(OS.window_size.y/2)/float($Background/Sky.rect_size.y) )*sky_stretch.y
			$Background/Sky.flip_v = 1
		else:
			$Background/Sky.rect_scale.y = 1
			$Background/Sky.flip_v = 0
		
		
		if sky_stretch.x > 0:
			$Background/Sky.rect_size.x = sky_stretch.x*($Background/Sky.texture.get_width())*2
			$Background/Sky.rect_scale.x = (OS.window_size.x/$Background/Sky.texture.get_width())/sky_stretch.x
		else:
			$Background/Sky.rect_size.x = ($Background/Sky.texture.get_width()+OS.window_size.x)
			$Background/Sky.rect_scale.x = 1
		
		
		
		if change_checker[1] != $Background/Sky.texture:
			print("-      TEXTURE: Sky changed")
			change_checker[1] = $Background/Sky.texture
			
		
		
		if sky_stretch.x < 1 && sky_stretch.x != 0 && sky_stretch.x != 0.5:
			print(">M I S T A K E: sky_stretch.x gotta be =0, =0,5, or >1!")
			if sky_stretch.x < 0:
				sky_stretch.x = 0
			else:
				sky_stretch.x = 1
		
		if change_checker[7] != sky_stretch:
			print("-  SKY_STRETCH: ",sky_stretch,", changed from ",change_checker[7])
			change_checker[7] = sky_stretch
			
		
	
	
	if change_checker[2] != $Background/Floor.texture or change_checker[6] != OS.window_size:
		$Background/Floor.scale = Vector2( (OS.window_size.x/$Background/Floor.texture.get_width())+1,    (OS.window_size.y/($Background/Floor.texture.get_height()/2))  )
		#$Background/Floor.scale = Vector2( (OS.window_size.x/$Background/Floor.texture.get_width()) + (abs(vroll_multi)*10),    (OS.window_size.y/($Background/Floor.texture.get_height()/2))  )
		
		
		if change_checker[2] != $Background/Floor.texture:
			print("-      TEXTURE: Floor changed")
			change_checker[2] = $Background/Floor.texture
			
		
	
	
	if change_checker[4] != draw_distance or change_checker[5] != angles or change_checker[6] != OS.window_size:
		var midscreenFirst = OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated(-deg_rad((angles)/2)) ).angle() ))
		var midscreenLast  = OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated( deg_rad((angles)/2)) ).angle() ))
		
		$PolyContainer.scale.x = abs(midscreenFirst - midscreenLast)
		$PolyContainer.scale.y = $PolyContainer.scale.x/OS.window_size.y
		
		lookingZ = 0
		
		
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
var new_container

var rot_plus90
var rot_minus90

var midscreen = 0

export(bool) var textures_on = 0
export(bool) var UV_textures = 1
export(bool) var cull_on = 1

func render():
	if (weakref(new_container).get_ref()):
		new_container.queue_free()
		
	new_container = $PolyContainer.duplicate()
	add_child(new_container)
	
	midscreen = (Vector2(0,draw_distance).rotated(rotation_angle)).angle()
	
	rot_plus90  = rad_overflow(rotation_angle+(PI/2))
	rot_minus90 = rad_overflow(rotation_angle-(PI/2))
	
	for n in array_walls.size():
		var new_poly = $PolyContainer/Poly0.duplicate()
		
		var array_polygon = []
		var outtasight = 0
		var min_distance = INF
		var array_shading = []
		
		for m in array_walls[n].points.size():
			var rot_object   = rad_overflow((array_walls[n].points[m]-to_global($Camera2D.position)).angle()-PI/2)
			
			
			#stretching fix conditions
			if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object < rot_minus90 or rot_object > rot_plus90))   or   (rot_object < rot_minus90 && rot_object > rot_plus90):
				var rot_object_plus  = rad_overflow((array_walls[n].points[ (m+1) % array_walls[n].points.size() ]-to_global($Camera2D.position)).angle()-PI/2)
				var rot_object_minus = rad_overflow((array_walls[n].points[ (m-1) % array_walls[n].points.size() ]-to_global($Camera2D.position)).angle()-PI/2)
				var neighbours_pm = Vector2(0,0) #pm = "plus, minus"
				
				
				if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object_plus < rot_minus90 or rot_object_plus > rot_plus90))   or   (rot_object_plus < rot_minus90 && rot_object_plus > rot_plus90):
					neighbours_pm.x = 1
				
				if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object_minus < rot_minus90 or rot_object_minus > rot_plus90))   or   (rot_object_minus < rot_minus90 && rot_object_minus > rot_plus90):
					neighbours_pm.y = 1
				
				
				if (neighbours_pm.x == 1) && (neighbours_pm.y == 1):  #both neighbours bad, delete
					pass
				
				
				
				else:
					#Ctrigger = true
					#shading = false
					#C = -(1*(float(1*array_walls[n].darkness)/draw_distance)-1)
					var limitPlus  = to_global($Camera2D.position)+(Vector2(0,100).rotated(rotation_angle+PI/2))
					var limitMinus = to_global($Camera2D.position)+(Vector2(0,100).rotated(rotation_angle-PI/2))
					var point1 = array_walls[n].points[m]
					var point2
					var height1 = array_walls[n].heights[m]
					var height2
					
					
					if (neighbours_pm.x == 0) && (neighbours_pm.y == 1):#minus neighbour bad, go with plus neighbour
						point2 = array_walls[n].points[ (m+1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m+1) % array_walls[n].heights.size() ]
					
					else:#plus/both neighbour bad, go with minus neighbour
						point2 = array_walls[n].points[ (m-1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m-1) % array_walls[n].heights.size() ]
						
						#if (neighbours_pm.x == 0) && (neighbours_pm.y == 0):
						#	Ctrigger = true
					
					
					var new_position = new_position(point1, point2, limitPlus, limitMinus, (point1.x - point2.x)*(limitPlus.y - limitMinus.y) - (point1.y - point2.y)*(limitPlus.x - limitMinus.x))  +  Vector2(0,1).rotated(rotation_angle)
					#func new_position(point1,point2,height1,height2,limitPlus,limitMinus,det):
					var xkusu = (new_position-to_global($Camera2D.position)).angle() - midscreen
					var lineH = (OS.window_size.y / (sqrt(pow((new_position.x - to_global($Camera2D.position).x), 2) + pow((new_position.y - to_global($Camera2D.position).y), 2))))   /  cos(xkusu) #Logic from other raycasters
					
					var C = 1
					if !shading: C = float(1)/array_walls[n].darkness
					else: C = -(    sqrt(pow((new_position.x - to_global($Camera2D.position).x), 2) + pow((new_position.y - to_global($Camera2D.position).y), 2) + pow((array_walls[n].heights[m] - positionZ), 2))    *(float(1*array_walls[n].darkness)/draw_distance)-1)
					#var distance = sqrt(pow((array_walls[n].points[m].x - to_global($Camera2D.position).x), 2) + pow((array_walls[n].points[m].y - to_global($Camera2D.position).y), 2) + pow((array_walls[n].heights[m] - positionZ), 2))
					#-(distance*(float(1*array_walls[n].darkness)/draw_distance)-1)
					
					if height1 == height2:#No diagonals, we're done
						array_polygon.append(Vector2(tan(xkusu), ((positionZ+ply_height)*lineH)-lineH*array_walls[n].heights[m])) #OVER
						
					else:#Need to make diagonal clipping
						var new_height = (sqrt(pow((point2.x - new_position.x), 2) + pow((point2.y - new_position.y), 2))/sqrt(pow((point2.x - point1.x), 2) + pow((point2.y - point1.y), 2)))*(height1-height2)
						
						if height2 > height1: #dont know
							new_height += height2
						elif height2 < height1:# why, OK
							#if (new_height < height2) or (new_height > height1):
							new_height += height2
						
						#print(height2,"   ",height1,"   ",new_height)
						
						array_polygon.append(Vector2(tan(xkusu), ((positionZ+ply_height)*lineH)-lineH*new_height)) #OVER
					
					array_shading.append(Color(C,C,C))
					
					if neighbours_pm.x == neighbours_pm.y:#both good neighbours (1 vertex clipping, need extra point)
						point2 = array_walls[n].points[ (m+1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m+1) % array_walls[n].heights.size() ]
						
						new_position = new_position(point1,point2,limitPlus,limitMinus,(point1.x - point2.x)*(limitPlus.y - limitMinus.y) - (point1.y - point2.y)*(limitPlus.x - limitMinus.x))  +  Vector2(0,1).rotated(rotation_angle)
						
						xkusu = (new_position-to_global($Camera2D.position)).angle() - midscreen
						lineH = (OS.window_size.y / (sqrt(pow((new_position.x - to_global($Camera2D.position).x), 2) + pow((new_position.y - to_global($Camera2D.position).y), 2))))   /  cos(xkusu) #Logic from other raycasters
						
						if shading: C = -(    sqrt(pow((new_position.x - to_global($Camera2D.position).x), 2) + pow((new_position.y - to_global($Camera2D.position).y), 2) + pow((array_walls[n].heights[m] - positionZ), 2))    *(float(1*array_walls[n].darkness)/draw_distance)-1)
						
						if height1 == height2:#No diagonals
							array_polygon.append(Vector2(tan(xkusu), ((positionZ+ply_height)*lineH)-lineH*array_walls[n].heights[m])) #OVER
						
						else:#diagonal
							var new_height = (sqrt(pow((point2.x - new_position.x), 2) + pow((point2.y - new_position.y), 2))/sqrt(pow((point2.x - point1.x), 2) + pow((point2.y - point1.y), 2)))*(height1-height2)
							
							if height2 > height1: #dont know
								new_height += height2
							elif (height2 < height1) or (new_height > height1):# why, OK
								#if new_height < height2:
								new_height += height2
							
							array_polygon.append(Vector2(tan(xkusu), ((positionZ+ply_height)*lineH)-lineH*new_height)) #OVER
						
						array_shading.append(Color(C,C,C))
			
			
			else:#all vertices in front of camera
				#shading = true
				var xkusu = (array_walls[n].points[m]-to_global($Camera2D.position)).angle() - midscreen
				var lineH = (OS.window_size.y / sqrt(pow((array_walls[n].points[m].x - to_global($Camera2D.position).x), 2) + pow((array_walls[n].points[m].y - to_global($Camera2D.position).y), 2)))   /  cos(xkusu)
				
				array_polygon.append(Vector2(tan(xkusu),((positionZ+ply_height)*lineH)-lineH*array_walls[n].heights[m])) #OVER
				var C
				if !shading: C = float(1)/array_walls[n].darkness
				else: C = -(    sqrt(pow((array_walls[n].points[m].x - to_global($Camera2D.position).x), 2) + pow((array_walls[n].points[m].y - to_global($Camera2D.position).y), 2) + pow((array_walls[n].heights[m] - positionZ), 2))    *(float(1*array_walls[n].darkness)/draw_distance)-1)
				array_shading.append(Color(C,C,C))
			
			if cull_on && array_polygon.size() > 0:
				if abs(array_polygon[array_polygon.size()-1].y*$PolyContainer.scale.y+(OS.window_size.y*lookingZ)) > OS.window_size.y/2:
					outtasight +=1
					
			
			var distance = sqrt(pow((array_walls[n].points[m].x - to_global($Camera2D.position).x), 2) + pow((array_walls[n].points[m].y - to_global($Camera2D.position).y), 2) + pow((array_walls[n].heights[m] - positionZ), 2))
			
			#if shading:
				#if C == null:
				#var C = float(1)/array_walls[n].darkness
				#if !Ctrigger:
				#	C = -(distance*(float(1*array_walls[n].darkness)/draw_distance)-1)
				
				#elif array_shading.size() != 0:
				#	var distanceC = sqrt(pow((array_walls[n].points[array_walls[n].points.size()-1].x - to_global($Camera2D.position).x), 2) + pow((array_walls[n].points[array_walls[n].points.size()-1].y - to_global($Camera2D.position).y), 2) + pow((array_walls[n].heights[array_walls[n].heights.size()-1] - positionZ), 2))
				#	C = -(distanceC*(float(1*array_walls[n].darkness)/draw_distance)-1)
				
				#else:
				#	var distanceC = sqrt(pow((array_walls[n].position.x - to_global($Camera2D.position).x), 2) + pow((array_walls[n].position.y - to_global($Camera2D.position).y), 2))
				#	C = -(distanceC*(float(1*array_walls[n].darkness)/draw_distance)-1)
				
				#array_shading.append(Color(C,C,C))
			
			#else:
			#	var C = float(1)/array_walls[n].darkness
			#	array_shading.append(Color(C,C,C))
			#	if Ctrigger: array_shading.append(Color(C,C,C))
			
			
			
			
			
			
			if -(distance*(float(8192)/draw_distance)-4096) < min_distance:
				min_distance = -(distance*(float(8192)/draw_distance)-4096)
			
			if m == array_walls[n].points.size()-1:#Last cycle, time to end things
				if outtasight > array_polygon.size()-1:
					new_poly.queue_free()
					break
					#continue
				
				#print(array_shading)
				
				if abs(min_distance) > 4096:
					#new_poly.z_index = 4096*sign(min_distance)
					#new_poly.visible = 0
					#break #if we don't cull it gets inverted since things will stack at -4096
					new_poly.z_index = -4095
					new_poly.modulate = Color(0,0,0,array_walls[n].modulate.a)
					
				else:
					new_poly.z_index = min_distance
					
					new_poly.modulate = array_walls[n].modulate
					
					if textures_on: #Texture mapping
						new_poly.texture = load(array_walls[n].texture_path)
						new_poly.texture_rotation_degrees = array_walls[n].texture_rotate
						#new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()
						if UV_textures:
							var howmany = array_polygon.size() #m+1
							
							
							if  howmany == 3:
								new_poly.texture_offset = Vector2(0,0) + array_walls[n].texture_offset
								new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()
								new_poly.uv = [Vector2(0,0), Vector2(1,1), Vector2(0,1)]
							elif howmany == 4:
								new_poly.texture_offset = Vector2(0,0) + array_walls[n].texture_offset
								new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()
								new_poly.uv = [Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]
							elif howmany == 5:
								new_poly.texture_offset = Vector2(0,1) + array_walls[n].texture_offset
								new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/2
								new_poly.uv = [Vector2(2,4), Vector2(3,3), Vector2(4,4), Vector2(4,5), Vector2(2,5)]
							elif howmany == 6:
								new_poly.texture_offset = Vector2(1,2) + array_walls[n].texture_offset
								new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/4
								new_poly.uv = [Vector2(-1,3), Vector2(1,2), Vector2(3,3), Vector2(3,5), Vector2(1,6), Vector2(-1,5)]
							elif howmany == 7:
								new_poly.texture_offset = Vector2(1,0) + array_walls[n].texture_offset
								new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/4
								new_poly.uv = [Vector2(4,1), Vector2(5,0), Vector2(6,1), Vector2(7,3), Vector2(6,4), Vector2(4,4), Vector2(3,3)]
							elif howmany == 8:
								new_poly.texture_offset = Vector2(0,0) + array_walls[n].texture_offset
								new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/6
								new_poly.uv = [Vector2(1,1), Vector2(3,0), Vector2(5,1), Vector2(6,3), Vector2(5,5), Vector2(3,6), Vector2(1,5), Vector2(0,3)]
							elif  howmany == 9:
								new_poly.texture_offset = Vector2(1,-2) + array_walls[n].texture_offset
								new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/6
								new_poly.uv = [Vector2(0,3), Vector2(2,2), Vector2(4,3), Vector2(5,5), Vector2(4,7), Vector2(3,8), Vector2(1,8), Vector2(0,7), Vector2(-1,5)]
							elif howmany == 10:
								new_poly.texture_offset = Vector2(0,-1) + array_walls[n].texture_offset
								new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/6
								new_poly.uv = [Vector2(1,2), Vector2(2,1), Vector2(4,1), Vector2(5,2), Vector2(6,4), Vector2(5,6), Vector2(4,7), Vector2(2,7), Vector2(1,6), Vector2(0,4)]
								
						else:
							new_poly.texture_scale = $PolyContainer.scale * float(1)/array_walls[n].texture_repeat
							#new_poly.texture_offset.y = -positionZ
							#new_poly.texture_offset.x = rotation_angle
							
						
		#end of M loop, back to N
		
#		if !shading:
#			for j in array_polygon.size():
#				var C = float(1)/array_walls[n].darkness
#				array_shading.append(Color(C,C,C))
		
		new_poly.vertex_colors = array_shading
		new_poly.polygon = array_polygon
		new_container.add_child(new_poly) #Over!!!!
		
	
	if (weakref(new_container).get_ref()):
		for o in array_sprites.size():
			var new_sprite = $PolyContainer/Sprite0.duplicate()
			
			var xkusu = (array_sprites[o].position - position).angle() - midscreen
			var lineH = (OS.window_size.y /  sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2))) / cos(xkusu) 
			
			new_sprite.scale = Vector2( ((((OS.window_size.x /  sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2))) / cos(xkusu) )/$PolyContainer.scale.x) * 0.15) * array_sprites[o].scale_extra.x , lineH * array_sprites[o].scale_extra.y )
			if sign(array_sprites[o].scale_extra.x) != sign(new_sprite.scale.x):# < 0 :
				continue
			
			new_sprite.position = Vector2(tan(xkusu), ((positionZ)*lineH)-lineH*(array_sprites[o].positionZ-array_sprites[o].obj_height))
			
			new_sprite.texture = load(array_sprites[o].texture)
			
			if cull_on && (abs(new_sprite.position.y*$PolyContainer.scale.y+(OS.window_size.y*lookingZ)) > OS.window_size.y/2):
				continue
			
			
			new_sprite.vframes = array_sprites[o].vframes
			new_sprite.hframes = array_sprites[o].hframes
			new_sprite.offset.y = -new_sprite.texture.get_height()/10
			
			
			#lets re-use it
			#xkusu = -(sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2) + pow((array_sprites[o].positionZ - positionZ), 2)) *(float(8192)/draw_distance)-4096)
			xkusu = sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2) + pow((array_sprites[o].positionZ - positionZ), 2))
			if abs(-(xkusu*(float(8192)/draw_distance)-4096)) > 4096:
				#break
				new_sprite.modulate = Color(0,0,0)
				new_sprite.modulate.a8 = array_sprites[o].modulate.a8
				new_sprite.z_index = -4095
				
			else:
				var C
				if shading: C =  -(xkusu*(float(1*array_sprites[o].darkness)/draw_distance)-1)
				else: C = float(1)/array_sprites[o].darkness
				new_sprite.modulate = array_sprites[o].modulate*C
				new_sprite.modulate.a8 = array_sprites[o].modulate.a8
				new_sprite.z_index = -(xkusu*(float(8192)/draw_distance)-4096)
				
			
			
			
			if array_sprites[o].rotations > 1:
				var frame_rot = 0
				var angletester
				
				
				angletester = int(deg_overflow(rad_deg(rotation_angle) - array_sprites[o].rotation_degrees)+180) % 360
				
				
				for n in array_sprites[o].rotations:
					if (angletester < (360/(array_sprites[o].rotations+1))*n) or (angletester > 360-((360/(array_sprites[o].rotations+1))*n)):
						frame_rot = (n*new_sprite.hframes) - new_sprite.hframes
						if frame_rot < 0:
							frame_rot = 0
						
						if range(array_sprites[o].vframes*array_sprites[o].hframes).has(array_sprites[o].anim + frame_rot):
							new_sprite.frame = (array_sprites[o].anim + frame_rot) % (array_sprites[o].vframes*10)
							break
				
				
				if angletester > 180:
					new_sprite.flip_h = true
				
				
				
				
				
				
				
				
				
				
			
			new_container.add_child(new_sprite)
			
			if sprite_shadows:
				if new_sprite.position.y - new_sprite.offset.y > 0:
					var shadow = new_sprite.duplicate()
					shadow.scale.y *= -0.125
					#shadow.position.y = ((positionZ)*lineH)-lineH*(array_sprites[o].shadowZ-array_sprites[o].obj_height)
					shadow.position.y = ((positionZ)*lineH)-lineH*(array_sprites[o].shadowZ-array_sprites[o].shadow_height)
					shadow.modulate = Color(0,0,0)
					shadow.modulate.a8 = new_sprite.modulate.a8/2
					
					
					new_container.add_child(shadow)
				
			

export(bool) var shading = true
export(bool) var sprite_shadows = true


func new_position(point1,point2,limitPlus,limitMinus,det):
	var new_position
	
	if det != 0:
		new_position = Vector2(
		((point1.x*point2.y - point1.y*point2.x) * (limitPlus.x-limitMinus.x)  -  (point1.x-point2.x) * (limitPlus.x*limitMinus.y - limitPlus.y*limitMinus.x))/det,
		((point1.x*point2.y - point1.y*point2.x) * (limitPlus.y-limitMinus.y)  -  (point1.y-point2.y) * (limitPlus.x*limitMinus.y - limitPlus.y*limitMinus.x))/det)
	else:
		new_position = Vector2(0,0)
	
	return(new_position)



















var array_walls = []
var array_sprites = []

func _on_ViewArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("render"):
		if !array_walls.has(body):
			array_walls.push_back(body)
	
	elif body.is_in_group("rendersprite"):
		if !array_sprites.has(body):
			array_sprites.push_back(body)
	

func _on_ViewArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("render"):
		if array_walls.has(body):
			array_walls.erase(body)
	
	elif body.is_in_group("rendersprite"):
		if array_sprites.has(body):
			array_sprites.erase(body)
	
	if array_walls.size() == 0 && array_sprites.size() == 0 && (weakref(new_container).get_ref()):
		new_container.queue_free()


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














##############################################################################################################################################################################################
export var map_draw = 2

func _draw():
	if abs(map_draw) > 6:
		print(">M I S T A K E: map_draw value invalid!")
		map_draw = 6*sign(map_draw)
	
	if Worldconfig.zoom < 1:
		#draw_line(Vector2(-get_viewport().size.x/2, -get_viewport().size.y/2), Vector2(get_viewport().size.x/2, get_viewport().size.y/2), Color(1,1,1), 1)
		draw_line(Vector2(-get_viewport().size.x/2, -get_viewport().size.y/2), Vector2(get_viewport().size.x/2, -get_viewport().size.y/2), Color(1,0,0), 1)
		draw_line(Vector2(-get_viewport().size.x/2, get_viewport().size.y/2), Vector2(get_viewport().size.x/2, get_viewport().size.y/2), Color(1,0,0), 1)
		
		draw_line(Vector2(-get_viewport().size.x/2, get_viewport().size.y/2), Vector2(-get_viewport().size.x/2, -get_viewport().size.y/2), Color(1,0,0), 1)
		draw_line(Vector2(get_viewport().size.x/2, get_viewport().size.y/2), Vector2(abs(get_viewport().size.x)/2, -get_viewport().size.y/2), Color(1,0,0), 1)
		
	
	
	if Input.is_action_pressed("ui_accept"): #Must always update otherwise it doesn't dissapear
		var shine1 = Color((randi() % 2),(randi() % 2),(randi() % 2))
		var orange = Color(1, 0.5, 0)
		
		draw_line(Vector2(0,0), Vector2(0,draw_distance).rotated(rotation_angle), Color(1,1,1), 1)
		if sign(map_draw) == 1:
			draw_line(Vector2(0,0), Vector2(0,draw_distance*2).rotated(rotation_angle-deg_rad(angles/2)), shine1, 1)
			draw_line(Vector2(0,0), Vector2(0,draw_distance*2).rotated(rotation_angle+deg_rad(angles/2)), shine1, 1)
			draw_line(Vector2(0,draw_distance*2).rotated(rotation_angle-deg_rad(angles/2)), Vector2(0,draw_distance*2).rotated(rotation_angle+deg_rad(angles/2)), shine1, 1)
			
			draw_line(Vector2(0,9999).rotated(rotation_angle+PI/2), Vector2(0,9999).rotated(rotation_angle-PI/2), Color(0.5, 0, 1), 1)
		
		
		
		
		
		if abs(map_draw) == 1: #walls in area
			for n in array_walls.size():
				for m in array_walls[n].points.size():
					var zoomies = 1
					#if Worldconfig.zoom > 0:
					#	zoomies = float(1)/Worldconfig.zoom
					#else:
					#	zoomies = Worldconfig.Camera2D.zoom
					
					if m < array_walls[n].points.size()-1:
						draw_line((array_walls[n].points[m]-position)*zoomies, (array_walls[n].points[m+1]-position)*zoomies, orange, 1)
					else:
						draw_line((array_walls[n].points[array_walls[n].points.size()-1]-position)*zoomies, (array_walls[n].points[0]-position)*zoomies, orange, 1)
		
		
		
		elif abs(map_draw) == 2: #all walls
			var targets_in_scene = []
			targets_in_scene = get_tree().get_nodes_in_group("render") #Who is spawned
			
			if targets_in_scene.size() != 0: #If anyone at all
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
					
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								var zoomies = 1
								
								if m < targets_in_scene[n].points.size()-1:
									draw_line((targets_in_scene[n].points[m]-position)*zoomies, (targets_in_scene[n].points[m+1]-position)*zoomies, orange, 1)
								else:
									draw_line((targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position)*zoomies, (targets_in_scene[n].points[0]-position)*zoomies, orange, 1)
						targets_in_scene = []
		
		
		
		
		
		
		
		
		elif abs(map_draw) == 3: #3D walls in area
			for n in array_walls.size():
				for m in array_walls[n].points.size():
					
					if m < array_walls[n].points.size()-1:
						draw_line(((array_walls[n].heights[m]+1) / lookingZ/1000)*(array_walls[n].points[m]-position), ((array_walls[n].heights[m+1]+1) / lookingZ/1000)*(array_walls[n].points[m+1]-position), orange, 1)
					else:
						draw_line(((array_walls[n].heights[array_walls[n].points.size()-1]+1) / lookingZ/1000)*(array_walls[n].points[array_walls[n].points.size()-1]-position), ((array_walls[n].heights[0]+1) / lookingZ/1000)*(array_walls[n].points[0]-position), orange, 1)
			
		
		elif abs(map_draw) == 4: #all 3D walls
			var targets_in_scene = []
			targets_in_scene = get_tree().get_nodes_in_group("render") #Who is spawned
			
			if targets_in_scene.size() != 0: #If anyone at all
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
						
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line(((targets_in_scene[n].heights[ m                                 ]+1) / lookingZ/1000) * (targets_in_scene[n].points[ m                                 ]-position),  ((targets_in_scene[n].heights[m+1]+1) / lookingZ/1000)*(targets_in_scene[n].points[m+1]-position), orange, 1)
									
								else:
									draw_line(((targets_in_scene[n].heights[targets_in_scene[n].points.size()-1]+1) / lookingZ/1000) * (targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position),  ((targets_in_scene[n].heights[ 0 ]+1) / lookingZ/1000)*(targets_in_scene[n].points[ 0 ]-position), orange, 1)
									
						
						targets_in_scene = []
		
		
		
		
		elif abs(map_draw) == 5: #3D walls in area 2
			for n in array_walls.size():
				for m in array_walls[n].points.size():
					
					
					if m < array_walls[n].points.size()-1:
						draw_line((1+array_walls[n].heights[ m                            ] * lookingZ/1000) * (array_walls[n].points[ m                            ]-position),  (1+array_walls[n].heights[m+1] * lookingZ/1000)*(array_walls[n].points[m+1]-position), orange, 1)
						
					else:
						draw_line((1+array_walls[n].heights[array_walls[n].points.size()-1] * lookingZ/1000) * (array_walls[n].points[array_walls[n].points.size()-1]-position),  (1+array_walls[n].heights[ 0 ] * lookingZ/1000)*(array_walls[n].points[ 0 ]-position), orange, 1)
						
		
		elif abs(map_draw) == 6: #all 3D walls 2
			var targets_in_scene = []
			targets_in_scene = get_tree().get_nodes_in_group("render") #Who is spawned
			
			if targets_in_scene.size() != 0: #If anyone at all
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
						
						
						
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line((1+targets_in_scene[n].heights[ m                                 ] * lookingZ/1000) * (targets_in_scene[n].points[ m                                 ]-position),  (1+targets_in_scene[n].heights[m+1] * lookingZ/1000)*(targets_in_scene[n].points[m+1]-position), orange, 1)
									
								
								else:
									draw_line((1+targets_in_scene[n].heights[targets_in_scene[n].points.size()-1] * lookingZ/1000) * (targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position),  (1+targets_in_scene[n].heights[ 0 ] * lookingZ/1000)*(targets_in_scene[n].points[ 0 ]-position), orange, 1)
									
						targets_in_scene = []
		
		
		#print(position)


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


func array_multiply(array, mult):
	for n in array.size():
		array[n] = array[n]*mult
	
	return array

func array_divide(array, div):
	for n in array.size():
		array[n] = array[n]/div
	
	return array


func array_looping(to_check, array_size):
	if to_check < 0:
		to_check += array_size
	
	if to_check > array_size-1:
		to_check -= array_size
	
	
	if (to_check < 0) or (to_check > array_size-1):
		to_check = array_looping(to_check, array_size)
	
	return(to_check)



