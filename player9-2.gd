extends KinematicBody2D

var motion = Vector2()

# Change these to change textures in the game #
onready var Floor = $Background/Floor
onready var Sky = $Background/Sky
#$SpriteContainer.Sprite0 --- has to be square
#$View/Feet --- haven't tested it
#this image is 2304x256y, all top 121y are transparent

export var angles = 120
export var angles_mult = 3.0

var rays = []
#var sprites = []

var texture_width
var texture_cellsize

func _ready():
	angles *= angles_mult
	#multiply FOV
	
	$RayContainer/Ray0.cast_to.y = draw_distance
	for n in angles:
		var new_ray = $RayContainer/Ray0.duplicate()                            #a new ray for every angle
		new_ray.rotation_degrees = ( (n/angles_mult) - (angles/angles_mult)/2 ) #extra (angles_mult) rays for every degree
		$RayContainer.add_child(new_ray)
		
		rays.append(new_ray)
		#Spawn rays and link to rays[] array
		
	
	$RayContainer/Ray0.queue_free()       #creator of clones, but unused
	#Delete unused
	
	$RayContainer.visible = 1
	$Background.visible = 1
	$View/Feet.visible = 1
	#Turn everything on
	
	
	texture_change_check = [$View/Feet.texture, Sky.texture, Floor.texture, feet_stretch]
	#Checks if things changed and updates
	
#	if draw_type > 0:
#		draw_type2_minH = (sqrt(pow(0, 2) + pow((draw_distance), 2)) )
#
#		var new_sprite = $SpriteContainer/Sprite0.duplicate()
#		$SpriteContainer.add_child((new_sprite))
#		new_sprite.self_modulate = Color(0,0,0,1)
#		new_sprite.z_index -= 1
#		sprites.append(new_sprite)
	#Create extra sprite for draw distance horizon wall
	# ONLY IF DRAW_TYPE POSITIVE, STILL WORKS IF NEGATIVE BUT WITH NO WALL
	
	window_size_check = Vector2(0,0)
	recalculate_window()
	
	new_container = $PolyContainer2

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

var feetY = 0



var positionZ = 0.1
#var motionZ = 0
#const GRAVITY = 1
#const JUMP = -10

var posZ_lookZ = 0.1
#Used for sky & floor position according to draw_distance

var lookingZ = 0
#export var lookZscaling = 0.5
#var lookZscale = 0
#View pans up and down

func _physics_process(_delta):
	# Input, motion, rotation
	########################################################################################################################################################
	########################################################################################################################################################
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = Vector2(speed*move_dir.x, speed*move_dir.y).rotated(rotation_angle)
	$RayContainer.rotation_degrees = rad_deg(rotation_angle) #radian to degrees
	
	
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
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	# Input, motion, rotation
	
	
	
	
	# SpriteContainer's vbob (position.y)
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
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	# SpriteContainer's vbob (position.y)
	
	
	
	#Z PROCESS
	########################################################################################################################################################
	########################################################################################################################################################
	if Input.is_action_pressed("ply_jump"):
		positionZ -= 1
	elif Input.is_action_pressed("ply_crouch"):
		positionZ += 1
	elif Input.is_action_pressed("ply_flycenter"):
		positionZ = lerp(positionZ, 0, 0.1)
	#print(positionZ)
	#print(lookingZ)
	if Input.is_action_pressed("ply_lookup"):
		if lookingZ > -360:
			lookingZ -= rotate_rate
	elif Input.is_action_pressed("ply_lookdown"):
		if lookingZ < 360:
			lookingZ += rotate_rate
	elif Input.is_action_pressed("ply_lookcenter"):
		lookingZ = lerp(lookingZ, 0, 0.1)
	
	
	#lookZscale = (abs(lookingZ)*lookZscaling/OS.window_size.y)# + abs($SpriteContainer.rotation_degrees)
	
	posZ_lookZ = -OS.window_size.y*(positionZ/(draw_distance*10))  -OS.window_size.y*(lookingZ/100)
	#Used for sky & floor position according to draw_distance
	
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	# Z process
	
	
	
	
	# $Sprite_Container, $Sky, $Floor, $View/Feet:  positionY
	########################################################################################################################################################
	########################################################################################################################################################
	#vbob and vroll
	#$SpriteContainer.position.y = abs(vbob) -OS.window_size.y*(lookingZ/100)
	$PolyContainer.position.y = abs(vbob) -OS.window_size.y*(lookingZ/100) #+(OS.window_size.y*(lookingZ/9))
	$PolyContainer.rotation_degrees = lerp($PolyContainer.rotation_degrees, (-input_dir.x*vroll_multi),00.1)/vroll_strafe_divi
	$Background.rotation_degrees = $PolyContainer.rotation_degrees
	
	
	########################################################################################################################################################
	#Sky.rect_size.y = Sky.texture.get_height()
	
	if sky_stretch.y == 1:
		#Sky.rect_scale.y = -(OS.window_size.y/2)/float(Sky.rect_size.y) 
		Sky.rect_position.y = (Sky.rect_size.y  /OS.window_size.y) + abs(vbob) +vbob_max +posZ_lookZ
		Sky.flip_v = 1
		
	else:
		Sky.rect_scale.y = 1
		Sky.rect_position.y = -Sky.rect_size.y + abs(vbob) +vbob_max +posZ_lookZ
		Sky.flip_v = 0
	
	#Sky.rect_size.x = (Sky.texture.get_width()+OS.window_size.x)*2 #unrelated to Z ############################################
	if sky_stretch.x == 1:                                                                                                    #
		Sky.rect_position.x = (-OS.window_size.x/2) - ( $RayContainer.rotation_degrees*(float(OS.window_size.x)/360) )        #
		#Sky.rect_scale.x = (OS.window_size.x/Sky.texture.get_width())                                                         #
		
	else:                                                                                                                     #
		Sky.rect_position.x = (-OS.window_size.x/2) - ( $RayContainer.rotation_degrees*(float(Sky.texture.get_width())/360) ) #
		Sky.rect_scale.x = 1  #################################################################################################
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	
	
	
	########################################################################################################################################################
	if sign(Floor.position.y/OS.window_size.y) < 0:         #Floor doesn't stretch until looking down limit, it ends around when Sky is out of view
		VisualServer.set_default_clear_color(Floor.modulate)# and changes the skycolor to its color when that limit is reached
	else:
		VisualServer.set_default_clear_color(skycolor)
	
	
	Floor.position.y = (OS.window_size.y) + abs(vbob) +posZ_lookZ
	#Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	
	
	
	########################################################################################################################################################
	if lookingZ > 180: #feet when looking down, imprecise to collision shape
		$View/Feet.visible = 1
		
		$View/Feet.scale.y = (OS.window_size.y/lookingZ)*2
		#$View/Feet.scale.x = OS.window_size.x/$View/Feet.texture.get_width()*10
		$View/Feet.rotation_degrees = (-input_dir.x*vroll_strafe_divi)*$View/Feet.scale.y*2
		
		$View/Feet.position.y = (OS.window_size.y/$View/Feet.texture.get_height())  +$View/Feet.scale.y*5
		feetY = $View/Feet.position.y
		
	
	elif lookingZ > 140:
		$View/Feet.visible = 1
		$View/Feet.position.y = feetY - ((lookingZ-180)*$View/Feet.scale.y)
		
	
	else:
		$View/Feet.visible = 0
	
	
	
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	#Feet animations
	if input_dir.y != 0:
		$AnimationPlayer.play("walk")
		$AnimationPlayer.playback_speed = input_dir.y
	
	elif input_dir.x != 0:
		if Input.is_action_pressed("ui_select"):
			if input_dir.x == -1:
				$AnimationPlayer.play("strafeR")
			else:
				$AnimationPlayer.play("strafeL")
			
		else:
			$AnimationPlayer.play("spin")
			$AnimationPlayer.playback_speed = input_dir.x
	
	
	else:
		$View/Feet.frame = 0
		$AnimationPlayer.stop()
	
	
	
	if window_size_check != OS.window_size:
		print("   RESOLUTION: ",OS.window_size,", changed from ",window_size_check)
		recalculate_window()
		
	
	elif texture_change_check != [$View/Feet.texture, Sky.texture, Floor.texture, feet_stretch]:
		if texture_change_check[0] != $View/Feet.texture:
			print("-      TEXTURE: Feet changed")
		elif texture_change_check[1] != Sky.texture:
			print("-      TEXTURE: Sky changed")
		elif texture_change_check[2] != Floor.texture:
			print("-      TEXTURE: Floor changed")
		elif texture_change_check[3] != feet_stretch:
			print("-      TEXTURE: feet_stretch changed")
		
		recalculate_window()
		
	
	elif rays[0].cast_to.y != draw_distance:
		print("-DRAW DISTANCE: ",draw_distance,", changed from ",rays[0].cast_to.y)
		
		for n in angles-1:
			rays[n].cast_to.y = draw_distance
		
		if draw_type > 0:
			draw_type2_minH = (sqrt(pow(0, 2) + pow((draw_distance), 2)) )
			#sprites[angles].scale.y = OS.window_size.y/draw_type2_minH
		
	
	else:
		update()

#####    #####      #####       #####  ##########   ##########  #########
##   ##  ##   ##  ##     ###  ##       ##           ###         ###
#####    #####    ##     ###  ##       ##########   ##########  #########
##       ##   ##  ##     ###  ##       ##                  ###         ##
##       ##   ##    #####       #####  ##########   ##########  #########

################################################################################
################################################################################
################################################################################
################################################################################



export var feet_stretch = 1

var window_size_check #Things only always checking for screen_size changes
var texture_change_check     #Array checking if texture becomes different
func recalculate_window():
	Sky.rect_size.y = Sky.texture.get_height()
	Sky.rect_scale.y = -(OS.window_size.y/2)/float(Sky.rect_size.y) 
	
	Sky.rect_size.x = (Sky.texture.get_width()+OS.window_size.x)*2
	Sky.rect_scale.x = (OS.window_size.x/Sky.texture.get_width())
	
	
	#Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	
	
	$View/Feet.scale.y = (OS.window_size.y/180)*2
	if feet_stretch == 1:
		$View/Feet.scale.x = OS.window_size.x/$View/Feet.texture.get_width()*10
	else:
		$View/Feet.scale.x = $View/Feet.scale.y 
	
	feetY = (OS.window_size.y/$View/Feet.texture.get_height())  +$View/Feet.scale.y*5
	
	
	#$View/Hand.scale = Vector2($View/Feet.scale.x, $View/Feet.scale.x)/2
	#$View/Hand.position.y = OS.window_size.y/3
	
	
	
#	if draw_type > 0:
#		sprites[angles].scale.y = OS.window_size.y/draw_type2_minH
#		sprites[angles].scale.x = OS.window_size.x*2
	
	
	
	texture_change_check = [$View/Feet.texture, Sky.texture, Floor.texture, feet_stretch]
	
	
	if window_size_check != OS.window_size:
		get_edgy = abs((OS.window_size.x * (0.5 * tan(deg_rad(rays[angles-1].rotation_degrees)))) - (OS.window_size.x * (0.5 * tan(deg_rad(rays[angles-1].rotation_degrees)))))                  #Distance between border renders
		var render_size = ((OS.window_size.x * (0.5 * tan(deg_rad(rays[0].rotation_degrees)))) + get_edgy) - ((OS.window_size.x * (0.5 * tan(deg_rad(rays[angles-1].rotation_degrees)))) - get_edgy) #Distance between screen edges
		#this re-uses the XKUSU code and must be way less efficient, but otherwise won't work?
		
		if render_size != 0:
			#$PolyContainer.scale.x = abs(OS.window_size.x/render_size)# + lookZscale
			
			window_size_check = OS.window_size
			print("A - O.K.!")
		else:
			$PolyContainer.scale.x = 1
	

var get_edgy = 0


####     ######           ####   ######   ####     ######   ##   ######
##  ##   ##               ##     ##  ##   ##  ##   ##            ##
####     ####      ###    ##     ##  ##   ##  ##   ####     ##   ##  ##
##  ##   ##               ##     ##  ##   ##  ##   ##       ##   ##  ##
##  ##   ######           ####   ######   ##  ##   ##       ##   ######

################################################################################
################################################################################
################################################################################
################################################################################





##############################################################################################################################################################################################

var highlighted_map_ray = (angles*angles_mult)/2

export var brightness = 20
export var brightMax = 255

export var line_gap_compensate = 0.3

export var draw_distance = 1000
export var draw_type = 2
export var draw_fade = 1.5
var   draw_type2_minH = 0

var wall_rendering_now
var polys = []


var new_container

func _draw():
	for n in angles-1: #fix this crap will ya? about time we start rendering with one less, it creates a gap when strafing left
		
		if n == 0: #loop proper
			wall_rendering_now = null
			new_container.queue_free()
			
			new_container = $PolyContainer.duplicate()
			add_child((new_container))
			
		
		
		if rays[n].is_colliding():
			var obj = rays[n].get_collider()
			
			if (obj.is_in_group("wall")) && obj != wall_rendering_now:
				var new_poly = $PolyContainer/Poly0.duplicate()
				new_container.add_child((new_poly))
				#polys.append(new_poly)
				
				
				#var lineH = (OS.window_size.y / distance) / cos( deg_rad(rays[n].rotation_degrees) ) 
				
				
				var distance1 = sqrt(pow((obj.line[0].x - position.x), 2) + pow((obj.line[0].y - position.y), 2)) #Logic from other raycasters
				var lineH1 = (OS.window_size.y / distance1)   /   cos(  deg_rad( (obj.line[0]-position).angle() ))
				#var xkusu1 = ( OS.window_size.x * (0.5 *          tan(  deg_rad( (obj.line[0]-position).angle() ) )))
				var xkusu1 = OS.window_size.x * tan(deg_rad((obj.line[0]-position).angle()))
				
				
				
				var distance2 = sqrt(pow((obj.line[1].x - position.x), 2) + pow((obj.line[1].y - position.y), 2)) #Logic from other raycasters
				var lineH2 = (OS.window_size.y / distance2)   /   cos(  deg_rad( (obj.line[1]-position).angle() ))
				#var xkusu2 = ( OS.window_size.x * (0.5 *          tan(  deg_rad( (obj.line[1]-position).angle() ) )))
				var xkusu2 = OS.window_size.x * tan(deg_rad((obj.line[1]-position).angle()))
				
				
				#var xkusu      = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n  ].rotation_degrees))   ))
				
				#what if we get the distance between something at 0 and 360 degrees
				#get the distance, therefore the render size
				#nononono
				#maybe we get -angles/2 to angles/2
				#and do something with it yeah
				
				
				if xkusu1 < xkusu2: #flip them right
					new_poly.set_polygon( PoolVector2Array([Vector2(xkusu1,-lineH1/2), Vector2(xkusu2,-lineH2/2), Vector2(xkusu2,lineH2/2), Vector2(xkusu1,lineH1/2)]) )
					
					#new_poly.position.x = xkusu1
				else:
					new_poly.set_polygon( PoolVector2Array([Vector2(xkusu2,-lineH2/2), Vector2(xkusu1,-lineH1/2), Vector2(xkusu1,lineH1/2), Vector2(xkusu2,lineH2/2)]) )
					
					#new_poly.position.x = xkusu2
				
				
				wall_rendering_now = obj
			
		else:
			wall_rendering_now = null
		
		
	
	
#	for m in polys.size():
#		var wr = weakref(polys[m])
#
#		if (!wr.get_ref()):
#			polys[m].queue_free()


var render_lines


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
