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
var sprites = []

var texture_width
var texture_cellsize

func _ready():
	
	texture_width = $SpriteContainer/Sprite0.texture.get_width()
	$SpriteContainer/Sprite0.hframes = texture_width
	
	texture_cellsize = texture_width/10
	$SpriteContainer.scale.y = float(10)/texture_cellsize
	# render scale Y according to texture size
	
	print(texture_width,"!   ",texture_width/10,"      ",texture_cellsize)
	# texture configuration
	
	
	
	
	angles *= angles_mult
	#multiply FOV
	
	$RayContainer/Ray0.cast_to.y = draw_distance
	for n in angles:
		var new_ray = $RayContainer/Ray0.duplicate()                            #a new ray for every angle
		new_ray.rotation_degrees = ( (n/angles_mult) - (angles/angles_mult)/2 ) #extra (angles_mult) rays for every degree
		$RayContainer.add_child(new_ray)
		
		rays.append(new_ray)
		#Spawn rays and link to rays[] array
		
	
		var new_sprite = $SpriteContainer/Sprite0.duplicate()
		$SpriteContainer.add_child((new_sprite))
		sprites.append(new_sprite)
		#Spawn sprites (wall-lines) and link to sprites[] array
	
	
	$RayContainer/Ray0.queue_free()       #creator of clones, but unused
	$SpriteContainer/Sprite0.queue_free() #ditto
	sprites[angles-1].queue_free()        #render needs checking the next ray, so doesn't use last
	#Delete unused
	
	$SpriteContainer.visible = 1
	$RayContainer.visible = 0
	$Background.visible = 1
	$View/Feet.visible = 1
	#Turn everything on
	
	
	texture_change_check = [$View/Feet.texture, Sky.texture, Floor.texture, feet_stretch]
	#Checks if things changed and updates
	
	if draw_type > 0:
		draw_type2_minH = (sqrt(pow(0, 2) + pow((draw_distance), 2)) )
		
		var new_sprite = $SpriteContainer/Sprite0.duplicate()
		$SpriteContainer.add_child((new_sprite))
		new_sprite.self_modulate = Color(0,0,0,1)
		new_sprite.z_index -= 1
		sprites.append(new_sprite)
	#Create extra sprite for draw distance horizon wall
	# ONLY IF DRAW_TYPE POSITIVE, STILL WORKS IF NEGATIVE BUT WITH NO WALL
	
	window_size_check = Vector2(0,0)
	recalculate_window()

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
		
		if input_dir.y == -1: #down
			rotation_angle = 0
		
		elif input_dir.x == 1: #left
			rotation_angle = 0.5*PI
		
		elif input_dir.y == 1: #up
			rotation_angle = PI
		
		elif input_dir.x == -1: #right
			rotation_angle = 1.5*PI
			
	
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
	$SpriteContainer.position.y = abs(vbob) -OS.window_size.y*(lookingZ/100) #+(OS.window_size.y*(lookingZ/9))
	$SpriteContainer.rotation_degrees = lerp($SpriteContainer.rotation_degrees, (-input_dir.x*vroll_multi),00.1)/vroll_strafe_divi
	$Background.rotation_degrees = $SpriteContainer.rotation_degrees
	
	
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
			sprites[angles].scale.y = OS.window_size.y/draw_type2_minH
		
	
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
	
	
	$View/Hand.scale = Vector2($View/Feet.scale.x, $View/Feet.scale.x)/2
	$View/Hand.position.y = OS.window_size.y/3
	
	
	
	if draw_type > 0:
		sprites[angles].scale.y = OS.window_size.y/draw_type2_minH
		sprites[angles].scale.x = OS.window_size.x*2
	
	
	
	texture_change_check = [$View/Feet.texture, Sky.texture, Floor.texture, feet_stretch]
	
	
	if window_size_check != OS.window_size:
		#var get_edgy = abs(sprites[angles-3].position.x - sprites[angles-2].position.x) #Distance between border renders, angles-2 - angles-1 not work for some reason
		#var render_size = (sprites[0].position.x + get_edgy) - (sprites[angles-2].position.x - get_edgy) #Distance between screen edges
		
		#var xkusu      = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n  ].rotation_degrees))))
		get_edgy = abs((OS.window_size.x * (0.5 * tan(deg_rad(rays[angles-2].rotation_degrees)))) - (OS.window_size.x * (0.5 * tan(deg_rad(rays[angles-1].rotation_degrees)))))                  #Distance between border renders
		var render_size = ((OS.window_size.x * (0.5 * tan(deg_rad(rays[0].rotation_degrees)))) + get_edgy) - ((OS.window_size.x * (0.5 * tan(deg_rad(rays[angles-1].rotation_degrees)))) - get_edgy) #Distance between screen edges
		#for some reason the other code doesn't work unless all checked rays are colliding
		#this re-uses the XKUSU code and must be way less efficient, but it all only happens when the screen is being resized so whatever
		
		if render_size != 0:
			$SpriteContainer.scale.x = abs(OS.window_size.x/render_size)# + lookZscale
			
			window_size_check = OS.window_size
			print("A - O.K.!")
		else:
			$SpriteContainer.scale.x = 1
	

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



func _draw():
	for n in angles-1: #fix this crap will ya? about time we start rendering with one less, it creates a gap when strafing left
		if rays[n].is_colliding():
			var distance = sqrt(pow((rays[n].get_collision_point().x - position.x), 2) + pow((rays[n].get_collision_point().y - position.y), 2)) #Logic from other raycasters
			#Logic from other raycasters
			
			var lineH = (OS.window_size.y / distance) / cos( deg_rad(rays[n].rotation_degrees) ) 
			#Y scale, compensate fisheye with angle
			
			sprites[n].scale.y = lineH 
			sprites[n].position.y = (texture_cellsize) * ((-positionZ/100)*lineH) 
			#PositionZ according to texture_size, stretchier the longer distance (texture size)
			
			
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			
			var xkusu_next = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n+1].rotation_degrees))   )) #Position re-angled correctly
			var xkusu      = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n  ].rotation_degrees))   ))
			#position according to order, and distort distance like other raycaster logic fixing fish-eyes
			
			sprites[n].position.x = xkusu 
			sprites[n].scale.x = (xkusu - xkusu_next - angles_mult/10)-line_gap_compensate
			#distance between, according to multiplyer... still gotta fix the line_gap_compensate
			
			if n == angles-2: #Compensate for fucking gap on the right...
				sprites[n].scale.x -= get_edgy*2
				sprites[n].position.x += get_edgy
			
			
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			var tile_cell = Worldconfig.TileMap.get_cellv( Worldconfig.TileMap.world_to_map(rays[n].get_collision_point() - rays[n].get_collision_normal() * 0.001) )
			# Raycast collision point > Tilemap world-to-map > Tilemap get_cell ID
			
			if tile_cell == -1:
				tile_cell = 0
			# Guarantees no invalid textures that lag a lot
			
			
			var texture_x = abs(     rays[n].get_collision_point().x  -  (  int(rays[n].get_collision_point().x/10) *10  )     )*texture_cellsize/10
			# Magic? ( [collision point] - {[collision point]'s 'decade'} )*texture_cellsize/10
			
			var johncasey = 0
			# Used to decide if flip_v walls or not
			
			
			#Only flip square wall textures otherwise glitches
			if (Worldconfig.TileCol.get_cellv( Worldconfig.TileCol.world_to_map(rays[n].get_collision_point() - rays[n].get_collision_normal() * 0.001) )) == 0: 
				# Raycast collision point > Tilemap world-to-map > Tilemap get_cell ID == SQUARE ---- just checks if a square wall
				var true_n_angle = $RayContainer.rotation_degrees + rays[n].rotation_degrees
				
				if true_n_angle > 360:
					true_n_angle -= 360
				elif true_n_angle < 0:
					true_n_angle += 360
				# Rays[n] global angle, essentially
				
				
				
				if texture_x == 0: #if 'MAGIC' back there didn't register
					texture_x = abs(rays[n].get_collision_point().y - (int(rays[n].get_collision_point().y/10)*10))*texture_cellsize/10
					
					if true_n_angle < 180:
						if rays[n].get_collision_point().y > 0:
							johncasey = 1
						else:
							johncasey = 0
					
					
					else: 
						if rays[n].get_collision_point().y < 0:
							johncasey = 1
						else:
							johncasey = 0
				
				
				
				
				else:#if texture !=0: aka already calculated this
					if true_n_angle < 90 or true_n_angle > 270:
						if rays[n].get_collision_point().x > 0:
							johncasey = 1
						else:
							johncasey = 0
							
					
					
					
					else:#true_n_angle > 90 or true_n_angle < 270:
						if rays[n].get_collision_point().x < 0:
							johncasey = 1
						else:
							johncasey = 0
			# These are the conditions for flipping wall textures or not
			
			
			
			else:#if walls not SQUARE, just do whatever
				if texture_x == 0:
					texture_x = abs(rays[n].get_collision_point().y - (int(rays[n].get_collision_point().y/10)*10))*texture_cellsize/10
			
			
			
			var checkthis = ((tile_cell*texture_cellsize) - texture_x) + texture_cellsize #something is still wrong here I just don't know what
			
			if johncasey == 1 && checkthis < (sprites[0].vframes * sprites[0].hframes):
				sprites[n].frame = checkthis#((tile_cell*texture_cellsize) - texture_x) + texture_cellsize
				# though it also seems why they're getting fuzzy close to 0,0 for some reason
			
			elif johncasey == 0:
				sprites[n].frame = (tile_cell*texture_cellsize) + texture_x # don't know why but this extra math has got to be here otherwise X walls don't render
			# Ways of texturing... slightly different
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			var C = (lineH*brightness)
			if C > brightMax:
				C = brightMax
			# Depth-shading
			
			
			# Draw distance modes
			if draw_type == 0: #Disabled
				sprites[n].self_modulate = Color8(C, C, C, 255)
			
			
			else: #Enabled
				var Cfade = 255
				if distance > draw_distance/draw_fade:
					Cfade = brightMax/(distance-(draw_distance/draw_fade))
					
				elif abs(draw_type) == 2:
					Cfade = C
				# An automatic draw_fade would be cool
				
				
				if abs(draw_type) == 1: #Fade to transparency
					sprites[n].self_modulate = Color8(C, C, C, Cfade)
				
				elif abs(draw_type) == 2: #Fade to black
					if ((C+Cfade)/2) < C:
						C = (C+Cfade)/2
					
					sprites[n].self_modulate = Color8(C, C, C, 255)
					
			
			
			#And we're done!
			
			
			########################################################### Show map
			if Input.is_action_pressed("ui_accept"): 
				draw_line(Vector2(0,0), rays[n].get_collision_point() - position, Color8(C,C,C), 1)
				
				
				if rays[highlighted_map_ray].is_colliding():
					draw_line(Vector2(0,0), rays[highlighted_map_ray].get_collision_point() - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 1)
				
			####################################################################
		
		
		
		else:
			sprites[n].scale.y = 0
			
			########################################################### Show map
			if Input.is_action_pressed("ui_accept"): #Show map
				if !rays[highlighted_map_ray].is_colliding(): #mid ray
					draw_line(Vector2(0,0), rays[highlighted_map_ray].cast_to.rotated(rotation_angle), Color((randi() % 2),(randi() % 2),(randi() % 2)), 1)
				
				if !rays[0].is_colliding(): #first ray
					draw_line(Vector2(0,0), (rays[0].cast_to.rotated(rotation_angle + deg_rad(rays[0].rotation_degrees))), Color(1,1,1,1), 1)
				
				if !rays[angles-1].is_colliding(): #last ray
					draw_line(Vector2(0,0), (rays[angles-1].cast_to.rotated(rotation_angle + deg_rad(rays[angles-1].rotation_degrees))), Color(1,1,1,1), 1)
				
				
				#draw_line((rays[    0   ].cast_to.rotated(rotation_angle + deg_rad(rays[    0   ].rotation_degrees))), rays[highlighted_map_ray].cast_to.rotated(rotation_angle), Color(1,0,0,1), 1)
				#draw_line((rays[angles-1].cast_to.rotated(rotation_angle + deg_rad(rays[angles-1].rotation_degrees))), rays[highlighted_map_ray].cast_to.rotated(rotation_angle), Color(1,0,0,1), 1)
				
				
			####################################################################
	
#	if n == angles-1: #Compensate for fucking gap on the right...
#		sprites[angles-1].position.x = sprites[angles-2].position.x + get_edgy
#		sprites[angles-1].scale.y -= sprites[angles-2].scale.y
#		sprites[angles-1].scale.x -= get_edgy#*2
	
	if draw_type > 0: #the black horizon wall, ONLY IF DRAW_TYPE POSITION, OTHERWISE NO WALL
		sprites[angles].position.y = (texture_cellsize) * ((-positionZ/100)*(OS.window_size.y/draw_type2_minH))
	


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
