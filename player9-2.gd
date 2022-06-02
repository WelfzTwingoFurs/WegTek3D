extends KinematicBody2D

var motion = Vector2()

# Change these to change textures in the game #
onready var Floor = $Background/Floor
onready var Sky = $Background/Sky
#$SpriteContainer.Sprite0 --- has to be square
#$View/Feet --- haven't tested it
#this image is 2304x256y, all top 121y are transparent

export var angles = 120
#export var angles_multi = 3.0
var angles_multi = 1
#Still useful despite being polygon! Not implemented for now, but the idea is:
#Less angles checked, more performance
#More angles checked, more far-away details

var rays = []
#var sprites = []

var texture_width
var texture_cellsize

func _ready():
	angles *= angles_multi
	#multiply FOV
	
	$RayContainer/Ray0.cast_to.y = draw_distance
	for n in angles:
		var new_ray = $RayContainer/Ray0.duplicate()                            #a new ray for every angle
		new_ray.rotation_degrees = ( (n/angles_multi) - (angles/angles_multi)/2 ) #extra (angles_multi) rays for every degree
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

var posZlookZ = 0.1
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
		positionZ += 1
	elif Input.is_action_pressed("ply_crouch"):
		positionZ -= 1
	elif Input.is_action_pressed("ply_flycenter"):
		positionZ = lerp(positionZ, 0, 0.1)
	#print(positionZ)
	print(lookingZ)
	if Input.is_action_pressed("ply_lookup"):
		if lookingZ < 360:
			lookingZ += rotate_rate
	elif Input.is_action_pressed("ply_lookdown"):
		if lookingZ > -360:
			lookingZ -= rotate_rate
	elif Input.is_action_pressed("ply_lookcenter"):
		lookingZ = lerp(lookingZ, 0, 0.1)
	
	
	#lookZscale = (abs(lookingZ)*lookZscaling/OS.window_size.y)# + abs($SpriteContainer.rotation_degrees)
	
	posZlookZ = OS.window_size.y*(positionZ/(draw_distance)) + OS.window_size.y*(lookingZ/100)
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
	$PolyContainer.position.y = abs(vbob) +OS.window_size.y*(lookingZ/100) #+(OS.window_size.y*(lookingZ/9))
	#$PolyContainer.position.y = positionZ - (abs(vbob) -OS.window_size.y*(lookingZ/100))
	$PolyContainer.rotation_degrees = lerp($PolyContainer.rotation_degrees, (-input_dir.x*vroll_multi),00.1)/vroll_strafe_divi
	$Background.rotation_degrees = $PolyContainer.rotation_degrees
	
	
	########################################################################################################################################################
	#Sky.rect_size.y = Sky.texture.get_height()
	
	if sky_stretch.y == 1:
		#Sky.rect_scale.y = -(OS.window_size.y/2)/float(Sky.rect_size.y) 
		Sky.rect_position.y = (Sky.rect_size.y  /OS.window_size.y) + abs(vbob) +vbob_max +posZlookZ
		Sky.flip_v = 1
		
	else:
		Sky.rect_scale.y = 1
		Sky.rect_position.y = -Sky.rect_size.y + abs(vbob) +vbob_max +posZlookZ
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
	
	
	Floor.position.y = (OS.window_size.y) + abs(vbob) +posZlookZ
	#Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	if lookingZ < -280: #feet when looking down, imprecise to collision shape NEEDS WERKIN
		$View/Feet.scale.y = 1#-(OS.window_size.y/lookingZ)*2
		#$View/Feet.position.y = (OS.window_size.y/$View/Feet.texture.get_height()) + (OS.window_size.y*(lookingZ/100))
		$View/Feet.position.y = $PolyContainer.position.y
		
		
		
		lookingZ 
		$View/Feet.position.y
		$View/Feet.scale.y
		
		print(lookingZ,":  ",$View/Feet.position.y," ",$View/Feet.scale.y)
		
		
		
		
		
		
		$View/Feet.visible = 1
		$View/Feet.rotation_degrees = (-input_dir.x*vroll_strafe_divi)*$View/Feet.scale.y*2
		#feetY = $View/Feet.position.y
		
		
		
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
	
	else:
		$View/Feet.visible = 0
		$AnimationPlayer.stop()
	
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	
	
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
	
	
	Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	
	
	#$View/Feet.scale.y = (OS.window_size.y/180)*2
	if feet_stretch == 1:
		$View/Feet.scale.x = OS.window_size.x/$View/Feet.texture.get_width()*10
	else:
		$View/Feet.scale.x = $View/Feet.scale.y 
	
	#feetY = (OS.window_size.y/$View/Feet.texture.get_height())  +$View/Feet.scale.y*5
	
	
	#$View/Hand.scale = Vector2($View/Feet.scale.x, $View/Feet.scale.x)/2
	#$View/Hand.position.y = OS.window_size.y/3
	
	
	
#	if draw_type > 0:
#		sprites[angles].scale.y = OS.window_size.y/draw_type2_minH
#		sprites[angles].scale.x = OS.window_size.x*2
	
	
	
	texture_change_check = [$View/Feet.texture, Sky.texture, Floor.texture, feet_stretch]
	
	
	if window_size_check != OS.window_size:
		var midscreenFirst = OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated(-deg_rad((angles/angles_multi)/2)) ).angle() ))
		var midscreenLast  = OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated( deg_rad((angles/angles_multi)/2)) ).angle() ))
		
		$PolyContainer.scale.x = abs(midscreenFirst - midscreenLast)
		$PolyContainer.scale.y = (OS.window_size.x/midscreenFirst) - (OS.window_size.x/midscreenLast)
		
		window_size_check = OS.window_size
		print("And that's O-K.")
		
	
	print(position)


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

onready var highlighted_map_ray = (angles*angles_multi)/2
#onready!!

export var brightness = 20
export var brightMax = 255

export var draw_distance = 1000

var wall_rendering_now
var polys = []


var new_container


var midscreen = 0

func _draw():
	for n in angles-1: #fix this crap will ya? about time we start rendering with one less, it creates a gap when strafing left
		if n == 0: #loop proper, this is still rough and probably laggy but for now it'll do
			wall_rendering_now = null
			new_container.queue_free()
			
			new_container = $PolyContainer.duplicate()
			add_child((new_container))
			
			midscreen = (Vector2(0,draw_distance).rotated(rotation_angle)).angle()
			
		
		
		
		if rays[n].is_colliding():
			var obj = rays[n].get_collider()
			
			if (obj.is_in_group("wall")) && obj != wall_rendering_now:
				var new_poly = $PolyContainer/Poly0.duplicate()
				new_container.add_child((new_poly))
				
				
				var holyshit = (obj.line[0]-position).angle() - midscreen
				var xkusu1 = tan(holyshit)
				
				var distance1 = sqrt(pow((obj.line[0].x - position.x), 2) + pow((obj.line[0].y - position.y), 2)) #Logic from other raycasters
				var lineH1 = (OS.window_size.y / distance1)   /  cos(holyshit)
				#var lineH1 = (-positionZ/100)*((OS.window_size.y / distance1)   /  cos(holyshit))
				
				
				
				holyshit = (obj.line[1]-position).angle() - midscreen
				var xkusu2 = tan(holyshit)
				
				var distance2 = sqrt(pow((obj.line[1].x - position.x), 2) + pow((obj.line[1].y - position.y), 2)) #Logic from other raycasters
				var lineH2 = (OS.window_size.y / distance2)   /  cos(holyshit)
				#var lineH2 = (-positionZ/100)*((OS.window_size.y / distance2)   /  cos(holyshit))
				
				
				
				
				#var containers_posZ = OS.window_size.y*(positionZ/(draw_distance))
				var containers_posZ1 = (positionZ/100)*lineH1
				var containers_posZ2 = (positionZ/100)*lineH2
				
				if xkusu1 < xkusu2: #flip them right
					new_poly.set_polygon( PoolVector2Array([Vector2(xkusu1,containers_posZ1-lineH1*obj.height[0]), Vector2(xkusu2,containers_posZ2-lineH2*obj.height[1]), Vector2(xkusu2,containers_posZ2+lineH2*obj.height[2]), Vector2(xkusu1,containers_posZ1+lineH1*obj.height[3])]) )
				else:
					new_poly.set_polygon( PoolVector2Array([Vector2(xkusu2,containers_posZ2-lineH2*obj.height[1]), Vector2(xkusu1,containers_posZ1-lineH1*obj.height[0]), Vector2(xkusu1,containers_posZ1+lineH1*obj.height[3]), Vector2(xkusu2,containers_posZ2+lineH2*obj.height[2])]) )
				
				wall_rendering_now = obj #don't repeat rendering the same object
				
				#you know how Wolf3D shades walls EAST-WEST differently than NORTH-SOUTH?
				#well we could do that but with any angle
				#get angle obj_line[0] and [1], compare with desired angle and change tint
				
				
				
				
			
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


func angle_dont_overflow(holyshit):
	if   holyshit >  PI*2:
		holyshit -= PI*2
	elif holyshit < 0:
		holyshit += PI*2
	
	return holyshit

func angle_stretch(holyshit):
	if   holyshit >  4:
		holyshit -= PI*2
	elif holyshit < -4:
		holyshit += PI*2
	
	return holyshit





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
