extends KinematicBody2D
#OS.get_system_time_msecs()

var health = 1000

var motion = Vector2()

export var camera = false
export var noclip = false
var dontCollideSprite = false

export var angles = 145
export var draw_distance = 8192
export(float) var lod_ddist_divi = 2.5

export var rotate_rate = 3.0
export var speed = 1500
export(float) var steer_sensibility = 1


export(float) var GRAVITY = 0.5
export(float) var JUMP = 10
export var head_height = 100

export var positionZ = 0
export var min_Z = 0

export var vbob_max = 4.0
export var vbob_speed = 0.09
export var vroll_multi = -1.5
var vroll_car = 0
export var mouselock = false
var mousedir = Vector2(0,0)

export var map_draw = 2
export var map_scale = 0.1

export var skycolor = Color8(47,0,77)
export var scenetint = Color8(255,255,255)
var scenetint_current
export var sky_stretch = Vector2(1,1)
export(float) var bg_offset = 1
var skytimer = 0
#Used for sky & floor position according to draw_distance

export(bool) var cull_on = 1
export(bool) var textures_on = true
export var higfx = false
export(float) var shading = 1
export(bool) var sprite_shadows = true

onready var change_checker = []

var feet_terrain = 0

func _ready():
	Worldconfig.player = self
	Worldconfig.playercar = null
	Worldconfig.Camera2D = $Camera2D
	
	$Background.visible = 1
	$View/Feet.visible = 1
	$Camera2D.visible = 1
	$View/Hand.visible = 0
	#Turn everything on
	
	$ViewArea/ViewCol.polygon = [Vector2(0,0),   Vector2(0,draw_distance*2).rotated(-deg_rad(angles/2)),   Vector2(0,draw_distance*2).rotated( deg_rad(angles/2))]
	change_checker = [$View/Feet.texture, Vector2($Background/Sky.texture.get_size().length(),$Background/Sky2.texture.get_size().length()), $Background/Floor.texture, 0, draw_distance, angles, OS.window_size*0, sky_stretch]#, Color8(255,255,255)]
	#Checks if things changed and updates
	
	scenetint_current = scenetint

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










var rotation_angle = 0

var input_dir = Vector2(0,0)
var move_dir = Vector3(0,0,0)

var vbob = 0
var vroll_strafe_divi = 1 #changes if strafing

var posZlookZ = 0
var lookingZ = 0
var new_lookingZ = 0
#View pans up and down

func _input(event):
	if mouselock && (Worldconfig.playercar == null):
		if event is InputEventMouseMotion:
			mousedir = event.relative
			
			if (lookingZ < $PolyContainer.scale.y*10) or (lookingZ > -$PolyContainer.scale.y*10):
				lookingZ -= ($PolyContainer.scale.y/50)*mousedir.y
			rotation_angle += 0.0174533 * mousedir.x
			rotation_angle = rad_overflow(rotation_angle)
			
		else:
			mousedir = Vector2(0,0)
	
	#elif (Worldconfig.playercar != null):
	#	lookingZ = 0



func _physics_process(_delta):
	$ViewArea/ViewCol.rotation_degrees = rad_deg(rotation_angle) #radian to degrees
	$Interact.rotation_degrees = $ViewArea/ViewCol.rotation_degrees
	
	if (Worldconfig.playercar == null) && health > 0:
		motion = move_and_slide(motion, Vector2(0,-1))
		motion = Vector2(speed*move_dir.x, speed*move_dir.y).rotated(rotation_angle)
		
		if Input.is_action_pressed("ply_up"):
			input_dir.y = 1
			move_dir.y = 1
		
		elif Input.is_action_pressed("ply_down"):
			input_dir.y = -1
			move_dir.y = -1
		
		else: #no inputs
			input_dir.y = 0
			move_dir.y = 0
		
		
		if Input.is_action_pressed("ply_left"):
			input_dir.x = 1
			
			if Input.is_action_pressed("ply_strafe") or mouselock: #strafe
				move_dir.x = 1
				vroll_strafe_divi = 1
				
			else:
				vroll_strafe_divi = 1.3
				move_dir.x = 0
				
				rotation_angle -= 0.0174533 * rotate_rate #1 degree in radian
		
		
		elif Input.is_action_pressed("ply_right"):
			input_dir.x = -1
			
			if Input.is_action_pressed("ply_strafe") or mouselock: #strafe
				move_dir.x = -1
				vroll_strafe_divi = 1
				
			else:
				vroll_strafe_divi = 1.3
				move_dir.x = 0
				
				rotation_angle += 0.0174533 * rotate_rate #1 degree in radian
		
		
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
		if !mouselock:# && !autolook:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if Input.is_action_pressed("ply_lookup"): #3.6 won't cut it with the new Y-FOV stretching!
				if lookingZ < $PolyContainer.scale.y*10:
					lookingZ += rotate_rate*0.01 #* Engine.time_scale
			elif Input.is_action_pressed("ply_lookdown"):
				if lookingZ > -$PolyContainer.scale.y*10:
					lookingZ -= rotate_rate*0.01 #* Engine.time_scale
		#elif autolook:
		#elif (Worldconfig.playercar != null && camera):
		#	lookingZ = lerp(lookingZ, new_lookingZ, 0.1)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		
		#mousedir = lerp(mousedir, Vector2(0,0), 1)
		
		if Input.is_action_just_pressed("bug_lockmouse"):
			mouselock = !mouselock
		
		if Input.is_action_pressed("ply_lookcenter"):
			lookingZ = lerp(lookingZ, 0, 0.1)
	
	
	
	
	
	
		if Input.is_action_just_pressed("ply_wpn_next"):
			guninv += 1
			if guninv > 4: guninv = 0
			gunswitch()
		elif Input.is_action_just_pressed("ply_wpn_previous"):
			guninv -= 1
			if guninv < 0: guninv = 4
			gunswitch()
			
			
			
			
		if !gunbusy:
			if Input.is_action_pressed("ply_wpn_fire1"):
				gunfire(false)
			elif Input.is_action_just_released("ply_wpn_fire1"):
				gunstop(false)
			
			if Input.is_action_pressed("ply_wpn_fire2"):
				gunfire(true)
			elif Input.is_action_just_released("ply_wpn_fire2"):
				gunstop(true)
			
			
			
			if Input.is_action_just_pressed("ply_wpn_reload"):
				gunreload()
			
	
	
	
	
	
	
	
	
	
		if Input.is_action_just_pressed("ply_noclip"):
			health = 1000
			noclip = !noclip
			on_floor = false
		
	
	
	
		if !noclip:# && (Worldconfig.playercar == null):
			dontCollideSprite = false
			collide()
			
			if on_body == true:
				motionZ = 0
				positionZ = body_on.positionZ + body_on.head_height
				if Input.is_action_pressed("ply_jump"):
					$Feet.feet_jump()
					motionZ += JUMP
					on_body = false
				if col_sprites.size() == 0:
					on_body = false
			
			if on_floor == true:
				motionZ = 0
				if Input.is_action_pressed("ply_jump"):
					$Feet.feet_jump()
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
		
		else:#if (Worldconfig.playercar == null): #noclip zone
			dontCollideSprite = true
			motionZ = 0
			if Input.is_action_pressed("ply_jump"):
				positionZ += 1 * rotate_rate * Engine.time_scale
				move_dir.z = 1
			elif Input.is_action_pressed("ply_crouch"):
				positionZ -= 1 * rotate_rate * Engine.time_scale
				move_dir.z = -1
			elif Input.is_action_pressed("ply_flycenter"):
				positionZ = lerp(positionZ, 0-head_height, 0.1)
			else:
				move_dir.z = 0
		#print(positionZ)
		#print(lookingZ)
		
		############################################################################
	###   ######      ######   ###   ###   #########
	###   ###   ###   ##  ##   ###   ###      ###
	###   ###   ###   ######   ###   ###      ###
	###   ###   ###   ###      #########      ###
	
	elif health < 0:
		mouselock = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		motion = move_and_slide(motion, Vector2(0,-1))
		motion = lerp(motion, Vector2(),0.01)
		guninv = 0
		gunswitch()
		head_height = lerp(head_height, 10, 0.1)
		lookingZ = -0.01
		
		if Input.is_action_just_pressed("ply_noclip"):
			health = 1000
			head_height = 100
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	# ^^ Input, motion, rotation
	
	if noclip:
		$Col.disabled = true
	else:
		$Col.disabled = false
	
	
	if Input.is_action_just_pressed("bug_camera"):
		camera = !camera
		vroll_car = 0
		
		
		if (Worldconfig.playercar != null) && (!camera):
			guninv = -1
			gunswitch()
		else:
			guninv = 0
			gunswitch()
	
	if Input.is_action_just_pressed("ply_use"):
		$Interact/ColShape.disabled = false
		
	else:#if Input.is_action_just_released("ply_use"):
		$Interact/ColShape.disabled = true
		if (Worldconfig.playercar == null) && (guninv == -1):
			guninv = 0
			gunswitch()
	
	
	
	if motionZ < 0:
		move_dir.z = -1
	elif motionZ > 0:
		move_dir.z = 1
	elif motionZ == 0:
		move_dir.z = 0
	
	if Worldconfig.zoom < 2:
		#$View/Hand.position.x = 0#(get_viewport().size.x/2) - (($View/Hand.texture.get_size().x/$View/Hand.hframes)*gunscale)/2
		#$View/Hand.position.x = get_viewport().get_mouse_position().x - (($View/Hand.texture.get_size().x/$View/Hand.hframes)*$View/Hand.scale.x)
		if guninv > -1:
			$View/Hand.position.x = lerp($View/Hand.position.x, abs(vbob*10)*-input_dir.x, 0.01)
			$View/Hand.rotation_degrees = lerp($View/Hand.rotation_degrees, -input_dir.x*(vroll_strafe_divi)*-vroll_multi, 0.5)
			if !gunstretch:
				$View/Hand.position.y = lerp($View/Hand.position.y, (get_viewport().size.y/2) - (($View/Hand.texture.get_size().y/$View/Hand.vframes)*gunscale)/2 + abs(vbob)*vbob_max + abs(input_dir.x)*30 +lookingZ*5 +($PolyContainer.scale.y*50), 0.5) 
				$View/Hand.scale = Vector2(gunscale,gunscale)
			else:
				$View/Hand.scale.x = OS.window_size.x/$View/Hand.texture.get_width()
				#$View/Hand.scale.y = gunscale
				$View/Hand.scale.y = $View/Hand.scale.x
				$View/Hand.position.y = lerp($View/Hand.position.y, (get_viewport().size.y/2) - (($View/Hand.texture.get_size().y/$View/Hand.vframes))/2 + abs(vbob)*vbob_max + abs(input_dir.x)*30 +lookingZ*5 +($PolyContainer.scale.y*50), 0.5) 
				
			
		else: #DASHBOARD GRAPHICS
			if Input.is_action_pressed("ply_lookleft"):
				$View/Hand.position = lerp($View/Hand.position, Vector2( ($View/Hand.texture.get_width()*$View/Hand.scale.x)/4,        abs(vbob)*vbob_max +lookingZ*5 +($PolyContainer.scale.y*50)), 0.5)
			elif Input.is_action_pressed("ply_lookright"):
				$View/Hand.position = lerp($View/Hand.position, Vector2(-($View/Hand.texture.get_width()*$View/Hand.scale.x)/4,        abs(vbob)*vbob_max +lookingZ*5 +($PolyContainer.scale.y*50)), 0.5)
			else:
				$View/Hand.position = lerp($View/Hand.position, Vector2(0,abs(vbob)*vbob_max +lookingZ*5 +($PolyContainer.scale.y*50)), 0.5)
			
			
			$View/Hand.scale.x = (OS.window_size.x/$View/Hand.texture.get_width())*2
			$View/Hand.scale.y = (OS.window_size.y/$View/Hand.texture.get_height()) +($PolyContainer.scale.y/6)
			#get it to fill whole screen
	
	#Worldconfig.playeraim = positionZ + head_height +((lookingZ/($PolyContainer.scale.y*10))*450)
	
	##  ##    ##    ####    ####
	##  ##  ##  ##  ##  ##  ##  ##
	######  ######  ##  ##  ##  ##
	##  ##  ##  ##  ##  ##  ##  ##
	##  ##  ##  ##  ##  ##  ####
	
	
	
	
	
	# vv Sprite effects, vbob
	########################################################################################################################################################
	########################################################################################################################################################
	if (Worldconfig.playercar == null):
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
	#position.y = abs(vbob)

func _process(_delta):
	$Background.rotation_degrees = $PolyContainer.rotation_degrees
	$PolyContainer.position.y = OS.window_size.y*lookingZ + abs(vbob)
	if Worldconfig.playercar == null && !camera:
		$PolyContainer.rotation_degrees = lerp($PolyContainer.rotation_degrees, (-input_dir.x*vroll_multi),00.1)/vroll_strafe_divi
	else:
		$PolyContainer.rotation_degrees = vroll_car
	
	########################################################################################################################################################
	if sky_stretch.y > 0:
		$Background/Sky.rect_position.y = ($Background/Sky.rect_size.y/not_zero(OS.window_size.y)) +vbob_max +posZlookZ + abs(vbob)
		$Background/Sky2.rect_position.y = ($Background/Sky2.rect_size.y/not_zero(OS.window_size.y)) +vbob_max +posZlookZ + abs(vbob)
		
	else:
		$Background/Sky.rect_position.y = -$Background/Sky.rect_size.y +vbob_max +posZlookZ + abs(vbob)
		$Background/Sky2.rect_position.y = -$Background/Sky2.rect_size.y +vbob_max +posZlookZ + abs(vbob)
	
	
	skytimer += 0.1
	if skytimer > 360:
		skytimer = 0
	
	if sky_stretch.x > 0:
		$Background/Sky.rect_position.x = (-OS.window_size.x/2) - ($ViewArea/ViewCol.rotation_degrees*(float(OS.window_size.x)/360))
		$Background/Sky2.rect_position.x = (-OS.window_size.x/2) - (overflow($ViewArea/ViewCol.rotation_degrees+skytimer,0,360)*(float(OS.window_size.x)/360))
		
	else:
		$Background/Sky.rect_position.x = (-OS.window_size.x/2) - ( $ViewArea/ViewCol.rotation_degrees*(float($Background/Sky.texture.get_width())/360) ) 
		$Background/Sky2.rect_position.x = (-OS.window_size.x/2) - ( overflow($ViewArea/ViewCol.rotation_degrees+skytimer,0,360)*(float($Background/Sky2.texture.get_width())/360) ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	
	
	
	########################################################################################################################################################
	if sign($Background/Floor.position.y/not_zero(OS.window_size.y)) < 0:         #Floor doesn't stretch until looking down limit, it ends around when Sky is out of view
		VisualServer.set_default_clear_color($Background/Floor.modulate)# and changes the skycolor to its color when that limit is reached
	else:
		VisualServer.set_default_clear_color(skycolor*scenetint_current)
	
	
	$Background/Floor.position.y = OS.window_size.y+posZlookZ + abs(vbob)
	#Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	
	if abs(lookingZ) > $PolyContainer.scale.y*10:# don't overflow
		lookingZ = ($PolyContainer.scale.y*10) * sign(lookingZ)
	
	#posZlookZ = OS.window_size.y*(positionZ/draw_distance/10) + OS.window_size.y*lookingZ
	posZlookZ = ( (OS.window_size.y*(positionZ/not_zero(draw_distance*bg_offset)/10)) * ($PolyContainer.scale.y*10) )  +  OS.window_size.y*lookingZ
	#Used for sky & floor position according to draw_distance
	
	
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	####      ####      ####    ####      ##      ##  ####  ####  ####
	##  ##  ##          ##  ##  ##  ##  ##  ##  ##    ##    ##    ##
	####    ##  ####    ####    ####    ##  ##  ##    ####  ####  ####
	##  ##  ##    ##    ##      ##  ##  ##  ##  ##    ##      ##    ##
	####      ####      ##      ##  ##    ##      ##  ####  ####  ####
	
	
	var C = float(1)
	if darkness < 0: C *= -darkness
	elif darkness > 0: C /= darkness
	$View.modulate = Color(C,C,C)*scenetint_current
	$PolyContainer.modulate = scenetint_current
	$Background.modulate = scenetint_current
	
	if health > 0:
		scenetint_current = lerp(scenetint_current, scenetint, 0.1)
	
	
	if Worldconfig.playercar != null: #STEERING WHEEL GRAPHX
		if !camera:
			$View/Feet.z_index = 4096
			$View/Feet.visible = true
			$View/Feet.rotation_degrees = Worldconfig.playercar.turn * 45
			
			$View/Feet.position = ($View/Hand.position + (Worldconfig.playercar.steer_pos* $View/Hand.scale))# * $View/Hand.scale
			$View/Feet.scale = Vector2((($View/Hand.texture.get_width()*$View/Hand.scale.x/$View/Feet.texture.get_width()))/Worldconfig.playercar.steer_size_divi, $View/Feet.scale.x)
			#$View/Feet.scale = Vector2($View/Feet.scale.y,(($View/Hand.texture.get_height()*$View/Hand.scale.x/$View/Feet.texture.get_height()))/Worldconfig.playercar.steer_size_divi)
			
			#draw_line($View.position + $View/Hand.position + (Worldconfig.playercar.meter_speed_pos* $View/Hand.scale), ($View.position + $View/Hand.position + (Worldconfig.playercar.meter_speed_pos* $View/Hand.scale)) + Vector2(0,50).rotated(deg2rad((Worldconfig.playercar.motion.length()/Worldconfig.playercar.max_speed)*360)), Color(1,0,0), 3, true)
			#$View/test.position = ($View/Hand.position * $View/Hand.scale)# + (Worldconfig.playercar.meter_speed_pos * $View/Hand.scale)
			#$test.position = $View.position + $View/Hand.position + (Worldconfig.playercar.meter_speed_pos* $View/Hand.scale)
			#$test.scale = Vector2(1,1)#$View/Hand.scale
			#$test2.position = $test.position + Vector2(0,50).rotated(deg2rad((Worldconfig.playercar.motion.length()/Worldconfig.playercar.max_speed)*360))
			#print(Worldconfig.playercar.motion.length()/Worldconfig.playercar.max_speed)
			#$View/test.scale = Vector2((($View/Hand.texture.get_width()*$View/Hand.scale.x/$View/test.texture.get_width()))/Worldconfig.playercar.steer_size_divi, $View/test.scale.x)
			$View/Speed.visible = true
			$View/Speed.points = [$View.position + $View/Hand.position + (Worldconfig.playercar.meter_speed_pos* $View/Hand.scale), ($View.position + $View/Hand.position + (Worldconfig.playercar.meter_speed_pos* $View/Hand.scale)) + Vector2(0,$View/Hand.scale.y*50).rotated(deg2rad((Worldconfig.playercar.motion.length()/Worldconfig.playercar.max_speed)*360))]
			
			
		else:
			$View/Speed.visible = false
			$View/Feet.visible = false
		
	else:
		$View/Speed.visible = false
		$View/Feet.scale.x = OS.window_size.x/$View/Feet.texture.get_width()*10
		$View/Feet.z_index = 4095
		if lookingZ < 0:
		#var percent = -(lookingZ/$PolyContainer.scale.y*10)/100
		#$View/Feet.scale.y = OS.window_size.y/$View/Feet.texture.get_height() * percent
		#$View/Feet.position.y = ((get_viewport().size.y/2) - (get_viewport().size.y/2)*percent) + (1-percent)*100# + $PolyContainer.position.y - $PolyContainer.scale.y*10
			$View/Feet.scale.y = OS.window_size.y/$View/Feet.texture.get_height()
			if health > 0: $View/Feet.position.y = -((OS.window_size.y*-$PolyContainer.scale.y*10) - $PolyContainer.position.y)
			#else: $View/Feet.position.y = -((OS.window_size.y*-$PolyContainer.scale.y*0) - $PolyContainer.position.y)
			else: $View/Feet.position.y = lerp($View/Feet.position.y, (get_viewport().size.y/2) - ($View/Feet.texture.get_size().y * $View/Feet.scale.y)/2, 0.5)
			$View/Feet.visible = 1
		else:
			$View/Feet.visible = 0
		#$View/Feet.rotation_degrees = -input_dir.x*vroll_strafe_divi*2
		#feetY = $View/Feet.position.y
		
		if (on_floor or on_body) && (health > 0):
			if input_dir.y != 0:
				$View/AniPlayFeet.play("walk")
				$View/AniPlayFeet.playback_speed = input_dir.y

			elif input_dir.x != 0:
				if Input.is_action_pressed("ply_strafe"):
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
		
		
		elif health < 0:
			$View/Feet.frame = 9
		
		
		else:
			$View/AniPlayFeet.stop()
			if move_dir.z == 1:
				$View/Feet.frame = 7
			else:# move_dir.z == -1:
				$View/Feet.frame = 8
		

		#else:
		#	$View/Feet.visible = 0
		#	$View/AniPlayFeet.stop()
	
	########  ########  ########  ########
	####      ####      ####        ####
	######    ########  ######      ####
	####      ####      ####        ####
	####      ########  ########    ####
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	
	$Ambience.ambienceGDT()
	
	if rotation_angle < 0:
		rotation_angle = 2*PI #360 in radian
	
	if rotation_angle > 2*PI: #360 in radian
		rotation_angle = 0
	
	
	if change_checker != [$View/Feet.texture, Vector2($Background/Sky.texture.get_size().length(),$Background/Sky2.texture.get_size().length()), $Background/Floor.texture, 0, draw_distance, angles, OS.window_size, sky_stretch]:#, scenetint]:
		recalculate()
	else:
		update()
		if Input.is_action_pressed("bug_closeeyes"):
			$Background.visible = 0
			$View.visible = 0
			VisualServer.set_default_clear_color(0)
			#update()
			if (weakref(new_container).get_ref()):
				new_container.queue_free()
			
			if Input.is_action_pressed("bug_zoomplus") && Input.is_action_pressed("bug_zoomminus"):
				map_scale = 1
			elif Input.is_action_pressed("bug_zoomplus"):
				if map_scale < 0.99:
					map_scale += 0.01
			elif Input.is_action_pressed("bug_zoomminus"):
				if map_scale > 0.02:
					map_scale -= 0.01
			
			
		elif Input.is_action_just_released("bug_closeeyes"):
			#update()
			$Background.visible = 1
			$View.visible = 1
			
		
		else:
			render()

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


func _on_Interact_body_entered(body):
	if body.is_in_group("interact"):
		if body.is_in_group("car"):
			Worldconfig.playercar = body
			guninv = 0
			gunswitch()
			
			noclip = true
		
		elif body.is_in_group("ped"):
			body.player_hi()

#INTERACT













################################################################################
################################################################################
################################################################################

var guninv = 0
export var gunscale = 3
export var hudscale = 3
var gunstretch = false
export var feet1 = preload("res://assets/feet1.png")
export var feet2 = preload("res://assets/feet2.png")
export var lefthanded = false



func gunswitch():
	#print("-       WEAPON: ", guninv)
	if guninv == 0:
		$View/Hand.visible = 0
		$View/Feet.texture = feet1
		$View/Feet.hframes = 10
	else:
		$View/Hand.visible = 1
		$View/Feet.texture = feet2
		$View/Feet.hframes = 10
	
	
	if guninv == -1:
		$View/Hand.texture = load(Worldconfig.playercar.dashboard)
		$View/Hand.hframes = 1
		$View/Hand.vframes = 1
		gunstretch = true
		$View/Feet.texture = load(Worldconfig.playercar.steeringwheel)
		$View/Feet.hframes = 1
		
	
	elif guninv == 1:
		$View/Hand.texture = load("res://assets/weapon fist.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 4
		gunstretch = false
		
	elif guninv == 2:
		$View/Hand.texture = load("res://assets/weapon pistol.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 13
		gunstretch = false
	
	elif guninv == 3:
		$View/Hand.texture = load("res://assets/weapon flamethrower.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 7
		gunstretch = false
		
	elif guninv == 4:
		$View/Hand.texture = load("res://assets/weapon doomarms.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 1
		gunstretch = false
		
	
	
	$View/Hand.frame = 0
	$View/Hand.flip_h = lefthanded
	
	if guninv != -1:
		$View/Hand.rotation_degrees = 90
		$View/Hand.position.y += $View/Hand.texture.get_size().x * $View/Hand.scale.x
	else:
		$View/Hand.rotation_degrees = 0











func gunfire(alt):
	if guninv == 1:
		if Input.is_action_just_pressed("ply_wpn_fire1") or Input.is_action_just_pressed("ply_wpn_fire2"):
			if ($View/AniPlayHand.current_animation_position > 0.2) or ($View/AniPlayHand.current_animation != "fist-punch"):
				$View/AniPlayHand.stop()
				$View/AniPlayHand.play("fist-punch")
				
				if Input.is_action_just_pressed("ply_wpn_fire2"):
					$View/Hand.flip_h = false
				elif Input.is_action_just_pressed("ply_wpn_fire1"):
					$View/Hand.flip_h = true
	
	
	
	
	
	elif guninv == 2:
		if Input.is_action_just_pressed("ply_wpn_fire1") or Input.is_action_just_pressed("ply_wpn_fire2"):
			if ammo2loaded > 0:
				ammo2loaded -= 1
				$View/AniPlayHand.stop()
				$View/AniPlayHand.play("hand-fire")
			else:
				$View/AniPlayHand.stop()
				$View/AniPlayHand.play("hand-empty")
	
	
	
	
	elif guninv == 3:
		if $View/Hand.frame == 5 or $View/Hand.frame == 4 or $View/Hand.frame == 3 or $View/Hand.frame == 2: darkness = 1
		
		if !alt && Input.is_action_just_pressed("ply_wpn_fire1") && ($View/Hand.frame != 4 or $View/Hand.frame != 3):
			if $View/AniPlayHand.current_animation == "flame-no":
				$View/AniPlayHand.play("flame-fire")
			else:
				$View/AniPlayHand.play("flame-start")
		elif alt:
			if $View/AniPlayHand.current_animation == "flame-start" or $View/AniPlayHand.current_animation == "flame-fire":
				$View/AniPlayHand.play("flame-fire")
			else:
				$View/AniPlayHand.play("flame-no")
				
	
	
	
	elif guninv == 4:
		if Input.is_action_just_pressed("ply_wpn_fire1") or Input.is_action_just_pressed("ply_wpn_fire2"): shoot()








func gunstop(alt):
	if guninv == 2:
		if alt && $View/AniPlayHand.current_animation == "flame-fire":
			$View/AniPlayHand.play("flame-end")
			$View/AniPlayHand.play("flame-end")
		elif $View/AniPlayHand.current_animation == "flame-no":
			$View/Hand.frame = 0








const shot = preload("res://objects/bullet.tscn")
#const shot = preload("res://chaser.tscn")
func shoot():
	if guninv == 2:
		var speedy = 10000
		
		var shoot_instance = shot.instance()
		shoot_instance.positionZ = positionZ + head_height +((lookingZ/($PolyContainer.scale.y*10))*500)
		shoot_instance.position = position + Vector2(50,0).rotated(rotation_angle + PI/2)
		
		
		var fartnogger = (lookingZ/($PolyContainer.scale.y*10))
		shoot_instance.motion = Vector2(speedy-(speedy*abs(lookingZ/($PolyContainer.scale.y*10))), 0).rotated(rotation_angle + PI/2)
		shoot_instance.motionZ = ((fartnogger*2)*speedy/10)  *  (lookingZ/($PolyContainer.scale.y*10))
		
		#lookingZ = (0.135-0.01)*($PolyContainer.scale.y*10)
		
		
		
		
		
		
		
		
		shoot_instance.motionZ = (1.6*speedy/10)  *  (lookingZ/($PolyContainer.scale.y*10))
		#shoot_instance.motionZ = (16-(16*abs(lookingZ/($PolyContainer.scale.y*10))))  *  (lookingZ/($PolyContainer.scale.y*10))
		shoot_instance.daddy = self
		add_collision_exception_with(shoot_instance)
		shoot_instance.add_collision_exception_with(self)
		get_parent().add_child(shoot_instance)
	
	elif guninv == 4:
		var uno = load("res://objects/car Uno.tscn").instance()
		uno.position = position + Vector2(50,0).rotated(rotation_angle + PI/2)
		get_parent().add_child(uno)





export var gunbusy = false

var ammo2loaded = 17
var ammo2stock = 170

func gunreload():
	if guninv == 2:
		if ammo2stock > 0:
			$View/AniPlayHand.play("hand-reload")


func update_ammo_out():
	if guninv == 2:
		ammo2loaded = 0

func update_ammo_in():
	if guninv == 2:
		if ammo2stock > 17:
			ammo2loaded = 17
			ammo2stock -= 17
		else:
			ammo2loaded = ammo2stock
			ammo2stock = 0






################    ####        ####    ####            ####
####                ####        ####    ########        ####
####        ####    ####        ####    ####    ####    ####
################    ################    ####        ########

func damage(damage,_daddy):
	scenetint_current = Color8(255,0,0)
	health -= damage



################################################################################
var motionZ = 0

var on_floor = false
var col_floors = []
var col_walls = []
var col_sprites = []



var darkness = 1

var on_body = false
var body_on = null
export var stepover = false

func collide():
	for n in col_sprites.size():
		if col_sprites[n].dontCollideSprite:
			add_collision_exception_with(col_sprites[n])
		else:
			var heightsBT = Vector2(-1,1)
			
			heightsBT.x = col_sprites[n].positionZ
			heightsBT.y = col_sprites[n].positionZ+col_sprites[n].head_height
			
			
			#pé < baixo, cabeça > baixo
			#pé > baixo, cabeça < topo
			#pé < topo, cabeça > topo
			if (positionZ <= heightsBT.x && positionZ+head_height >= heightsBT.x) or (positionZ >= heightsBT.x && positionZ+head_height <= heightsBT.y) or (positionZ < heightsBT.y && positionZ+head_height >= heightsBT.y): 
				# pé < topo, cabeça > topo, pé - topo = <head_height
				if col_sprites[n].stepover && (positionZ < heightsBT.y && positionZ+head_height > heightsBT.y) && (positionZ - heightsBT.y < head_height):#think think think
					positionZ = heightsBT.y
					on_body = true
					body_on = col_sprites[n]
				
				elif col_sprites[n].stepover && (positionZ < heightsBT.x && positionZ+head_height > heightsBT.x) && ((positionZ+head_height) - heightsBT.x < head_height):#think think think
					positionZ = heightsBT.x - head_height -1
				
				else:
					remove_collision_exception_with(col_sprites[n])
			
			else:
				add_collision_exception_with(col_sprites[n])
	
	
	
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
			if (positionZ <= heightsBT.x && positionZ+head_height >= heightsBT.x) or (positionZ >= heightsBT.x && positionZ+head_height <= heightsBT.y) or (positionZ < heightsBT.y && positionZ+head_height >= heightsBT.y): 
				# pé < topo, cabeça > topo, pé - topo = <head_height
				if col_walls[n].jumpover && (positionZ < heightsBT.y && positionZ+head_height > heightsBT.y) && (positionZ - heightsBT.y < head_height/2):
					positionZ = heightsBT.y
					on_floor = true
				
				elif col_walls[n].jumpover && (positionZ < heightsBT.x && positionZ+head_height > heightsBT.x) && ((positionZ+head_height) - heightsBT.x < head_height/2):
					positionZ = heightsBT.x - head_height -1
					on_floor = false
				
				else:
					remove_collision_exception_with(col_walls[n])
			
			else:
				add_collision_exception_with(col_walls[n])
	
	for n in col_floors.size():
		darkness = col_floors[n].darkness
		
		if col_floors[n].flag_1height:
			col_proccess(n,col_floors[n].heights[0])
		
			#if autolook && on_floor && move_dir != Vector3(0,0,0):
			#	new_lookingZ = 0
		
		else:  #sometimes we gotta process a slope. So far the process is triangle-only but it works with whatever shape too
			var new_height = slope(
				Vector3(position.x,position.y,0), 
				Vector3(col_floors[n].points[0].x, col_floors[n].points[0].y, col_floors[n].heights[0]), 
				Vector3(col_floors[n].points[1].x, col_floors[n].points[1].y, col_floors[n].heights[1]), 
				Vector3(col_floors[n].points[2].x, col_floors[n].points[2].y, col_floors[n].heights[2])) #+ margin
			
			
			
#			if autolook && on_floor && move_dir != Vector3(0,0,0):
#				var test = -float(positionZ-new_height)
#				if test < 0:
#					new_lookingZ = test/50
#				else:
#					new_lookingZ = test/30
			
			
			
			
			
			
			if (col_floors[n].absolute == 1) && (positionZ < new_height):
				positionZ = new_height
				on_floor = true
			elif (col_floors[n].absolute == -1) && (positionZ + head_height > new_height):
				positionZ = new_height - head_height
				on_floor = false
				continue
			
			
			if move_dir:
				if new_height > positionZ + head_height:
					if new_height < positionZ + head_height + motionZ:
						motionZ = -motionZ
				
				elif new_height > positionZ:
					positionZ = new_height
					on_floor = true
				else:
					if on_floor:
						positionZ = new_height




func slope(v0,v1,v2,v3):
	var normal = (v2 - v1).cross(v3 - v1).normalized()
	var dir = Vector3(0.0, 0.0, 1.0)
	var r = v0 + dir * ((v1.dot(normal)) - v0.dot(normal)) / dir.dot(normal)
	
	return r.z
	










func col_proccess(n,col_height):
	if col_floors[n].absolute == -1:
		if positionZ > col_height-1:
			positionZ = col_height - head_height
			on_floor = false
	elif col_floors[n].absolute == 1:
		if positionZ < col_height-head_height:
			positionZ = col_height
			on_floor = true
	
	
	if move_dir.z == -1:
		if (positionZ < col_height) && (positionZ+head_height > col_height):
			positionZ = col_height# + head_height
			
			on_floor = true 
			if motionZ < 0:
				motionZ = 0
				
	
	if move_dir.z == 1:
		if (positionZ < col_height) && (positionZ+head_height > col_height):
			positionZ = col_height - head_height
			
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
	
	elif body.is_in_group("sprite") && body != self:
		if !col_sprites.has(body):
			col_sprites.push_back(body)



func _on_ColArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	#if body.is_in_group("floor"):
		
		if col_floors.has(body):
			on_floor = false
			col_floors.erase(body)
			
			if (col_floors.size() == 0):
				if (positionZ <= min_Z): positionZ = min_Z
				darkness = 1
			
	
	#if body.is_in_group("wall"):
		elif col_walls.has(body):
			col_walls.erase(body)
			
	
	#if body.is_in_group("sprite"):
		elif col_sprites.has(body):
			col_sprites.erase(body)
			on_body = false
			on_floor = false

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
		if guninv != -1: $View/Feet.scale.x = OS.window_size.x/$View/Feet.texture.get_width()*10
		
		if change_checker[0] != $View/Feet.texture:
			#print("-      TEXTURE: Feet changed")
			change_checker[0] = $View/Feet.texture
			
		
	
	
	if change_checker[1] != Vector2($Background/Sky.texture.get_size().length(),$Background/Sky2.texture.get_size().length()) or change_checker[7] != sky_stretch or change_checker[6] != OS.window_size:
		$Background/Sky.rect_size.y = $Background/Sky.texture.get_height()
		$Background/Sky2.rect_size.y = $Background/Sky2.texture.get_height()
		#$Background/Sky.rect_size.x = ($Background/Sky.texture.get_width()+OS.window_size.x)
		#$Background/Sky.rect_size.x = $Background/Sky.texture.get_width()*2
		
		
		if sky_stretch.y > 0:
			$Background/Sky.rect_scale.y = ( -(OS.window_size.y/2)/float($Background/Sky.rect_size.y) )*sky_stretch.y
			$Background/Sky2.rect_scale.y = ( -(OS.window_size.y/2)/float($Background/Sky2.rect_size.y) )*sky_stretch.y
			$Background/Sky.flip_v = 1
			$Background/Sky2.flip_v = 1
		else:
			$Background/Sky.rect_scale.y = 1
			$Background/Sky2.rect_scale.y = 1
			$Background/Sky.flip_v = 0
			$Background/Sky2.flip_v = 0
		
		
		if sky_stretch.x > 0:
			$Background/Sky.rect_size.x = sky_stretch.x*($Background/Sky.texture.get_width())*2
			$Background/Sky2.rect_size.x = sky_stretch.x*($Background/Sky2.texture.get_width())*2
			$Background/Sky.rect_scale.x = (OS.window_size.x/$Background/Sky.texture.get_width())/sky_stretch.x
			$Background/Sky2.rect_scale.x = (OS.window_size.x/$Background/Sky2.texture.get_width())/sky_stretch.x
		else:
			$Background/Sky.rect_size.x = ($Background/Sky.texture.get_width()+OS.window_size.x)
			$Background/Sky2.rect_size.x = ($Background/Sky2.texture.get_width()+OS.window_size.x)
			$Background/Sky.rect_scale.x = 1
			$Background/Sky2.rect_scale.x = 1
		
		
		
		if change_checker[1] != Vector2($Background/Sky.texture.get_size().length(),$Background/Sky2.texture.get_size().length()):
			print("-      TEXTURE: Sky changed")
			change_checker[1] = Vector2($Background/Sky.texture.get_size().length(),$Background/Sky2.texture.get_size().length())
			
		
		
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
		$PolyContainer.scale.y = $PolyContainer.scale.x/not_zero(OS.window_size.y)
		
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
		
		
	
	
#	if change_checker[8] != scenetint:
#		$View.modulate = scenetint_current
#		$PolyContainer.modulate = scenetint_current
#		$Background.modulate = scenetint_current
#
#		print("-    SCENETINT: ",scenetint,", changed from ",change_checker[8])
#		if scenetint_current!= scenetint:
#			change_checker[8] = scenetint



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



func render():
	if (weakref(new_container).get_ref()):
		new_container.queue_free()
		
	new_container = $PolyContainer.duplicate()
	add_child(new_container)
	
	midscreen = (Vector2(0,draw_distance).rotated(rotation_angle)).angle()
	
	rot_plus90  = rad_overflow(rotation_angle+(PI/2))
	rot_minus90 = rad_overflow(rotation_angle-(PI/2))
	
	for n in array_walls.size():
		if incoming_walls.has(array_walls[n]):
			if (array_walls[n].points[0] - position).length() > draw_distance/lod_ddist_divi:
				continue
		
		
		var new_poly = $PolyContainer/Poly0.duplicate()
		
		var array_polygon = []
		var outtasight = 0
		var min_distance = INF
		var array_shading = []
		
		for m in array_walls[n].points.size():
			var rot_object   = rad_overflow((array_walls[n].points[m]-position).angle()-PI/2)
			
			
			#stretching fix conditions
			if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object < rot_minus90 or rot_object > rot_plus90))   or   (rot_object < rot_minus90 && rot_object > rot_plus90):
				var rot_object_plus  = rad_overflow((array_walls[n].points[ (m+1) % array_walls[n].points.size() ]-position).angle()-PI/2)
				var rot_object_minus = rad_overflow((array_walls[n].points[ (m-1) % array_walls[n].points.size() ]-position).angle()-PI/2)
				var neighbours_pm = Vector2(0,0) #pm = "plus, minus"
				
				
				if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object_plus < rot_minus90 or rot_object_plus > rot_plus90))   or   (rot_object_plus < rot_minus90 && rot_object_plus > rot_plus90):
					neighbours_pm.x = 1
				
				if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object_minus < rot_minus90 or rot_object_minus > rot_plus90))   or   (rot_object_minus < rot_minus90 && rot_object_minus > rot_plus90):
					neighbours_pm.y = 1
				
				
				if (neighbours_pm.x == 1) && (neighbours_pm.y == 1):  #both neighbours bad, delete
					pass#continue#passd
				
				
				
				else:
					var limitPlus  = position+(Vector2(0,100).rotated(rotation_angle+PI/2))
					var limitMinus = position+(Vector2(0,100).rotated(rotation_angle-PI/2))
					var point1 = array_walls[n].points[m]
					var point2
					var height1 = array_walls[n].heights[m] + array_walls[n].extraZ[m]
					var height2
					
					
					if (neighbours_pm.x == 0) && (neighbours_pm.y == 1):#minus neighbour bad, go with plus neighbour
						point2 = array_walls[n].points[ (m+1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m+1) % array_walls[n].heights.size() ] + array_walls[n].extraZ[ (m+1) % array_walls[n].extraZ.size() ]
					
					else:#plus/both neighbour bad, go with minus neighbour
						point2 = array_walls[n].points[ (m-1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m-1) % array_walls[n].heights.size() ] + array_walls[n].extraZ[ (m-1) % array_walls[n].extraZ.size() ]
						
					
					
					var new_position = new_position(point1, point2, limitPlus, limitMinus, (point1.x - point2.x)*(limitPlus.y - limitMinus.y) - (point1.y - point2.y)*(limitPlus.x - limitMinus.x))  +  Vector2(0,1).rotated(rotation_angle)
					#func new_position(point1,point2,height1,height2,limitPlus,limitMinus,det):
					var xkusu = (new_position-position).angle() - midscreen
					var lineH = (OS.window_size.y / not_zero( (new_position - position).length()) )   /  cos(xkusu) #Logic from other raycasters
					
					var C = 1
					if !shading:
						if array_walls[n].darkness != 0:
							C = float(1)/array_walls[n].darkness
						else:
							C = 1
					
					
					if height1 == height2:#No diagonals, we're done
						array_polygon.append(Vector2(tan(xkusu), ((positionZ+head_height)*lineH)-lineH*(array_walls[n].heights[m]+array_walls[n].extraZ[m]))) #OVER
						
					else:#Need to make diagonal clipping
						var new_height = ((point2 - new_position).length()/(point2 - point1).length()*(height1-height2))
						
						
						if (height2 > height1)  or  (height2 < height1): #dont know
							new_height += height2
						
						
						array_polygon.append(Vector2(tan(xkusu), ((positionZ+head_height)*lineH)-lineH*new_height)) #OVER
					
					array_shading.append(Color(C,C,C))
					
					if neighbours_pm.x == neighbours_pm.y:#both good neighbours (1 vertex clipping, need extra point)
						point2 = array_walls[n].points[ (m+1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m+1) % array_walls[n].heights.size() ] + array_walls[n].extraZ[ (m+1) % array_walls[n].extraZ.size() ]
						
						new_position = new_position(point1,point2,limitPlus,limitMinus,(point1.x - point2.x)*(limitPlus.y - limitMinus.y) - (point1.y - point2.y)*(limitPlus.x - limitMinus.x))  +  Vector2(0,1).rotated(rotation_angle)
						
						xkusu = (new_position-position).angle() - midscreen
						lineH = (OS.window_size.y / not_zero( (new_position - position).length()) )   /  cos(xkusu) #Logic from other raycasters
						
						
						if height1 == height2:#No diagonals
							array_polygon.append(Vector2(tan(xkusu), ((positionZ+head_height)*lineH)-lineH*(array_walls[n].heights[m]+array_walls[n].extraZ[m]))) #OVER
						
						else:#diagonal
							var new_height = ((point2 - new_position).length()/(point2 - point1).length()*(height1-height2))
							
							if height2 > height1: #dont know
								new_height += height2 
							elif (height2 < height1) or (new_height > height1):# why, OK
								new_height += height2 
							
							
							array_polygon.append(Vector2(tan(xkusu), ((positionZ+head_height)*lineH)-lineH*new_height)) #OVER
						
						array_shading.append(Color(C,C,C))
			
			
			else:#all vertices in front of camera
				var xkusu = (array_walls[n].points[m]-position).angle() - midscreen
				var lineH = (OS.window_size.y / not_zero( (array_walls[n].points[m] - position).length()) )   /  cos(xkusu) #Logic from other raycasters
				#var lineH = (OS.window_size.y / not_zero( (Vector3(array_walls[n].points[m].x, array_walls[n].points[m].y, array_walls[n].heights[m]+array_walls[n].extraZ[m]) - Vector3(position.x, position.y, positionZ)).length()) )   /  cos(xkusu) #Logic from other raycasters
				
				array_polygon.append(Vector2(tan(xkusu),((positionZ+head_height)*lineH)-lineH*(array_walls[n].heights[m]+array_walls[n].extraZ[m]))) #OVER
				var C
				if !shading:
					if array_walls[n].darkness != 0:
						C = float(1)/array_walls[n].darkness
					else:
						C = 1
				
				else: C = -(    (Vector3(array_walls[n].points[m].x, array_walls[n].points[m].y, array_walls[n].heights[m]+array_walls[n].extraZ[m]) - Vector3(position.x, position.y, positionZ)).length()    *(float(shading*array_walls[n].darkness)/draw_distance)-1)
				array_shading.append(Color(C,C,C))
			
			if cull_on && array_polygon.size() > 0:
				if abs(array_polygon[array_polygon.size()-1].y*$PolyContainer.scale.y+(OS.window_size.y*lookingZ)) > OS.window_size.y/2:
					outtasight += sign(array_polygon[array_polygon.size()-1].y*$PolyContainer.scale.y+(OS.window_size.y*lookingZ))
					
			
			
			
			
			
			
			
			
			
			
			
			
			
			var distance = (Vector3(array_walls[n].points[m].x, array_walls[n].points[m].y, array_walls[n].heights[m]+array_walls[n].extraZ[m]) - Vector3(position.x, position.y, positionZ)).length()
			
			
			if -(distance*(float(8192)/draw_distance)-4096) < min_distance:
				min_distance = -(distance*(float(8192)/draw_distance)-4096)
			
			if m == array_walls[n].points.size()-1:#Last cycle, time to end things
				if array_walls[n].onesided != 0:
					if sign(array_walls[n].onesided) == 1:
						if Geometry.is_polygon_clockwise(array_polygon):
							new_poly.queue_free()
							break
					elif sign(array_walls[n].onesided) == -1:
						if !Geometry.is_polygon_clockwise(array_polygon):
							new_poly.queue_free()
							break
				
				
				
				
				
				if cull_on && (abs(outtasight) > array_polygon.size()-1):
					new_poly.queue_free()
					break
					
				
				
				
				if abs(min_distance) > 4096:
					new_poly.modulate = Color(0,0,0)
					new_poly.modulate.a8 = array_walls[n].modulate.a8/2
					new_poly.z_index = -4095
				else:
					new_poly.z_index = min_distance
					
				new_poly.modulate = array_walls[n].modulate
				
				if !textures_on && array_walls[n].textures_on && (array_walls[n].texture_path == "res://textures/chainfence.png" or array_walls[n].texture_path == "res://textures/chainfence2.png" or array_walls[n].texture_path == "res://textures/chainfence3.png" or array_walls[n].texture_path == "res://textures/stretchtest.png"):
					new_poly.modulate.a8 /= 2
				
				
				
				if (textures_on or array_walls[n].texture_path == "res://textures/wheelEGA64.png") && array_walls[n].textures_on && (array_walls[n].texture_path != "res://textures/solid1.png"): #Texture mapping
					new_poly.texture = load(array_walls[n].texture_path)
					new_poly.texture_rotation_degrees = array_walls[n].texture_rotate
					#new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()
					if array_walls[n].UV_textures:
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
						
						
		#end of M loop, back to N
		
		
		new_poly.vertex_colors = array_shading
		new_poly.polygon = array_polygon
		new_container.add_child(new_poly) #Over!!!!
		
	
	if (weakref(new_container).get_ref()):
		for o in array_sprites.size():
			var new_sprite = $PolyContainer/Sprite0.duplicate()
			
			var xkusu = (array_sprites[o].position - position).angle() - midscreen
			var lineH = (OS.window_size.y / not_zero( (array_sprites[o].position - position).length()) )   /  cos(xkusu) #Logic from other raycasters
			
			new_sprite.scale = Vector2( ((((OS.window_size.x /  not_zero((array_sprites[o].position - position).length())) / cos(xkusu) )/$PolyContainer.scale.x) * (180-angles)/1000) * array_sprites[o].scale_extra.x *4,
			lineH * array_sprites[o].scale_extra.y)
			
			
			
			
			if sign(array_sprites[o].scale_extra.x) != sign(new_sprite.scale.x):
				continue
			
			if( (array_sprites[o].dontScale == -1) && ((new_sprite.scale.x < array_sprites[o].scale_extra.x/$PolyContainer.scale.x) or (new_sprite.scale.y < array_sprites[o].scale_extra.y/$PolyContainer.scale.y))) or ((array_sprites[o].dontScale == 1) && ((new_sprite.scale.x > array_sprites[o].scale_extra.x/$PolyContainer.scale.x) or (new_sprite.scale.y > array_sprites[o].scale_extra.y/$PolyContainer.scale.y))) or (array_sprites[o].dontScale == 2):
				new_sprite.scale = array_sprites[o].scale_extra/$PolyContainer.scale
			
			new_sprite.position = Vector2(tan(xkusu), ((positionZ)*lineH)-lineH*(array_sprites[o].positionZ-head_height+array_sprites[o].spr_height) )
			
			new_sprite.texture = array_sprites[o].texture
			
			#if cull_on && (abs(new_sprite.position.y*$PolyContainer.scale.y+(OS.window_size.y*lookingZ)) > OS.window_size.y/2):
			#	continue
			
			
			new_sprite.vframes = array_sprites[o].vframes
			new_sprite.hframes = array_sprites[o].hframes
			if !array_sprites[o].dontScale:
				new_sprite.offset.y = -new_sprite.texture.get_height()/10
			
			
			
			if !array_sprites[o].dontZ:#lets re-use xkusu
				xkusu = (Vector3(array_sprites[o].position.x, array_sprites[o].position.y, array_sprites[o].positionZ) - Vector3(position.x, position.y, positionZ)).length()
				if abs(-(xkusu*(float(8192)/draw_distance)-4096)) > 4096:
					#break
					new_sprite.modulate = Color(0,0,0)
					new_sprite.modulate.a8 = array_sprites[o].modulate.a8/2
					new_sprite.z_index = -4095
					
				else:
					var C
					if shading: C =  -(xkusu*(float(shading*array_sprites[o].darkness)/draw_distance)-1)
					elif array_sprites[o].darkness > 0: C = float(1)/array_sprites[o].darkness
					else: C = float(1)*-array_sprites[o].darkness
					new_sprite.modulate = array_sprites[o].modulate*C
					new_sprite.modulate.a8 = array_sprites[o].modulate.a8
					new_sprite.z_index = -(xkusu*(float(8192)/draw_distance)-4096)
					
			else:
				new_sprite.z_index = 4096
			
			
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
					if (frame_rot == 0) && !array_sprites[o].flip_frontback:
						pass
					else: new_sprite.flip_h = true
				
				
				
			else:
				new_sprite.frame = array_sprites[o].anim
			
			
			
			
			
			new_container.add_child(new_sprite)
			
			if sprite_shadows && array_sprites[o].shadow:## && (array_sprites[o].positionZ > positionZ-head_height):# && (new_sprite.position.y+(new_sprite.texture.get_size().y*new_sprite.scale.y)/2 > 0):
				var shadow = new_sprite.duplicate()
				
				shadow.z_index = new_sprite.z_index-1
				if !array_sprites[o].reflect:
					shadow.position.y = ((positionZ)*lineH)-lineH*(array_sprites[o].shadowZ-head_height+array_sprites[o].shadow_height )# - array_sprites[o].positionZ-array_sprites[o].shadow_height
					shadow.modulate = Color(0,0,0)
					shadow.modulate.a8 = new_sprite.modulate.a8/2 - abs(array_sprites[o].positionZ-array_sprites[o].shadowZ)/10
					shadow.scale.y *= 0.125
					shadow.scale.x *= 1.2
					
				elif array_sprites[o].reflect == 1:
					shadow.position.y = ((positionZ)*lineH)-lineH*(array_sprites[o].shadowZ-head_height+array_sprites[o].reflect_height)# + array_sprites[o].positionZ-array_sprites[o].shadow
					shadow.modulate.a8 = new_sprite.modulate.a8/1.5 - array_sprites[o].positionZ-array_sprites[o].shadowZ
					shadow.scale.y *= -0.25
					shadow.scale.x *= 0.7
					
				elif (array_sprites[o].reflect == 3) && array_sprites[o].on_floor: #blood
					shadow.position.y = ((positionZ)*lineH)-lineH*(array_sprites[o].shadowZ-head_height)
					shadow.modulate = Color(255 * array_sprites[o].bloodtimer,0,0)
					shadow.modulate.a8 = 127 * array_sprites[o].bloodtimer
					shadow.scale.y *= -0.5 * array_sprites[o].bloodtimer
					shadow.scale.x *= 1.5 * array_sprites[o].bloodtimer
				
				new_container.add_child(shadow)


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

var incoming_walls = []

func _on_ViewArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if !array_walls.has(body) or !array_sprites.has(body):
		if (higfx or (body.is_in_group("wall") or body.is_in_group("floor") or body.is_in_group("sprite") or body.is_in_group("logfx"))):# && body.is_in_group("render") or :
			if body.is_in_group("render"):
				array_walls.push_back(body)
				if !(body.is_in_group("wall") or body.is_in_group("floor")) && !body.is_in_group("logfx"):
					if !incoming_walls.has(body):
						for x in body.points.size():
							if (body.points[x] - position).length() < draw_distance/lod_ddist_divi:
								incoming_walls.push_back(body)
								break
		
		
		
		
		
		
		
		
		
		
			elif body.is_in_group("rendersprite"):# && (higfx or ((higfx) == (body.is_in_group("higfx")))):
			#elif (higfx && body.is_in_group("rendersprite")):# or (body.is_in_group("sprite") && body.is_in_group("rendersprite")):
				#if !array_sprites.has(body):
#				if !body.is_in_group("sprite"):
#					if (body.position - position).length() < draw_distance/2:
#						incoming_sprites.push_back(body)
#				else:
					array_sprites.push_back(body)
	

func _on_ViewArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if array_walls.has(body):
		array_walls.erase(body)
#		if incoming_walls.has(body):
#			incoming_walls.erase(body)
	
	elif array_sprites.has(body):
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


func _draw():
	if !Input.is_action_pressed("bug_closeeyes"):
		#if (Worldconfig.playercar != null) && !camera:
		#	draw_line($View.position + $View/Hand.position + (Worldconfig.playercar.meter_speed_pos* $View/Hand.scale), ($View.position + $View/Hand.position + (Worldconfig.playercar.meter_speed_pos* $View/Hand.scale)) + Vector2(0,50).rotated(deg2rad((Worldconfig.playercar.motion.length()/Worldconfig.playercar.max_speed)*360)), Color(1,0,0), 3, true)
		
		if Worldconfig.zoom < 1:
			draw_line(Vector2(-get_viewport().size.x/2, -get_viewport().size.y/2), Vector2(get_viewport().size.x/2, -get_viewport().size.y/2), Color(1,1,1), 1)
			draw_line(Vector2(-get_viewport().size.x/2, get_viewport().size.y/2), Vector2(get_viewport().size.x/2, get_viewport().size.y/2), Color(1,1,1), 1)
			draw_line(Vector2(-get_viewport().size.x/2, get_viewport().size.y/2), Vector2(-get_viewport().size.x/2, -get_viewport().size.y/2), Color(1,1,1), 1)
			draw_line(Vector2(get_viewport().size.x/2, get_viewport().size.y/2), Vector2(abs(get_viewport().size.x)/2, -get_viewport().size.y/2), Color(1,1,1), 1)
		
	else:
		if abs(map_draw) > 3:
			print(">M I S T A K E: map_draw value invalid!")
			map_draw = 3*sign(map_draw)
		
		
		
		#if Input.is_action_pressed("bug_closeeyes"): #Must always update otherwise it doesn't dissapear
		var shine = Color((randi() % 2),(randi() % 2),(randi() % 2))
		
		
		if sign(map_draw) == 1:
			draw_line(Vector2(0,0), Vector2(0,draw_distance).rotated(rotation_angle)*map_scale, Color(1,1,1), 1)
			
			draw_line(Vector2(0,0), Vector2(0,draw_distance*2).rotated(rotation_angle-deg_rad(angles/2))*map_scale, shine, 1)
			draw_line(Vector2(0,0), Vector2(0,draw_distance*2).rotated(rotation_angle+deg_rad(angles/2))*map_scale, shine, 1)
			draw_line(Vector2(0,draw_distance*2).rotated(rotation_angle-deg_rad(angles/2))*map_scale, Vector2(0,draw_distance*2).rotated(rotation_angle+deg_rad(angles/2))*map_scale, shine, 1)
			
			draw_line(Vector2(0,9999).rotated(rotation_angle+PI/2)*map_scale, Vector2(0,9999).rotated(rotation_angle-PI/2)*map_scale, Color(0.5, 0, 1), 1)
		
		else:
			draw_line(Vector2(0,-125).rotated(rotation_angle)*map_scale, Vector2(0,250).rotated(rotation_angle)*map_scale, shine, 1)
		
		
		
		
		
		
		
		
		
		
		
		var targets_in_scene = get_tree().get_nodes_in_group("render")
		#var targets_in_scene = get_tree().get_nodes_in_group("wall")
		
		
		if targets_in_scene.size() != 0: #If anyone at all
			if abs(map_draw) == 1: #all walls
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
					
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								var zoomies = 1
								
								if m < targets_in_scene[n].points.size()-1:
									draw_line(((targets_in_scene[n].points[m]-position)*zoomies)*map_scale, ((targets_in_scene[n].points[m+1]-position)*zoomies)*map_scale, targets_in_scene[n].modulate, 1)
								else:
									draw_line(((targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position)*zoomies)*map_scale, ((targets_in_scene[n].points[0]-position)*zoomies)*map_scale, targets_in_scene[n].modulate, 1)
									
						
						targets_in_scene = [] #reset
			
			
			elif abs(map_draw) == 2: #all 3D walls
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
						
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line(((targets_in_scene[n].heights[ m                                 ]+1) / not_zero(lookingZ)/1000) * (targets_in_scene[n].points[ m                                 ]-position),  ((targets_in_scene[n].heights[m+1]+1) / not_zero(lookingZ)/1000)*(targets_in_scene[n].points[m+1]-position), targets_in_scene[n].modulate, 1)
									
								else:
									draw_line(((targets_in_scene[n].heights[targets_in_scene[n].points.size()-1]+1) / not_zero(lookingZ)/1000) * (targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position),  ((targets_in_scene[n].heights[ 0 ]+1) / not_zero(lookingZ)/1000)*(targets_in_scene[n].points[ 0 ]-position), targets_in_scene[n].modulate, 1)
									
						
						targets_in_scene = [] #reset
			
			
			elif abs(map_draw) == 3: #all 3D walls 2
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
						
						
						
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line((1+targets_in_scene[n].heights[ m                                 ] * lookingZ/1000) * (targets_in_scene[n].points[ m                                 ]-position),  (1+targets_in_scene[n].heights[m+1] * lookingZ/1000)*(targets_in_scene[n].points[m+1]-position), targets_in_scene[n].modulate, 1)
									
								else:
									draw_line((1+targets_in_scene[n].heights[targets_in_scene[n].points.size()-1] * lookingZ/1000) * (targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position),  (1+targets_in_scene[n].heights[ 0 ] * lookingZ/1000)*(targets_in_scene[n].points[ 0 ]-position), targets_in_scene[n].modulate, 1)
									
						
						targets_in_scene = [] #reset



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


