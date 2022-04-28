extends KinematicBody2D

var motion = Vector2()

# Change these to change textures in the game #
onready var Floor = $Background/Floor
onready var Sky = $Background/Sky
#$SpriteContainer.Sprite0 --- has to be square
#$Feet --- haven't tested it
#this image is 2304x256y, all top 121y are transparent

export var angles = 120
export var angles_mult = 3.0

var rays = []
var sprites = []

var texture_width
var texture_cellsize

func _ready():
	#window_size_check = OS.window_size
	texture_width = $SpriteContainer/Sprite0.texture.get_width()
	$SpriteContainer/Sprite0.hframes = texture_width
	
	texture_cellsize = texture_width/10
	$SpriteContainer.scale.y = float(10)/texture_cellsize
	
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
	$Feet.visible = 1
	#Turn everything on
	
	
	texture_change_check = [$Feet.texture, Sky.texture, Floor.texture]
	
	
	if draw_type > 0:
		draw_type2_minH = (sqrt(pow(0, 2) + pow((draw_distance), 2)) )
		
		var new_sprite = $SpriteContainer/Sprite0.duplicate()
		$SpriteContainer.add_child((new_sprite))
		new_sprite.self_modulate = Color(0,0,0,1)
		new_sprite.z_index -= 1
		sprites.append(new_sprite)
	#Create extra sprite for draw distance

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

export var lookZscaling = 0.5
var lookingZ = 0
var lookZscale = 0

func _physics_process(_delta):
	update()
	
	
	
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
	
	
	if Input.is_action_just_pressed("bug_rotatecenter"):
		rotation_angle = 0
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
	
	
	posZ_lookZ = -OS.window_size.y*(positionZ/(draw_distance*10))  -OS.window_size.y*(lookingZ/100)
	#Used for sky & floor position according to draw_distance
	lookZscale = (abs(lookingZ)*lookZscaling/OS.window_size.y)
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	# Z process
	
	
	
	
	# $Sprite_Container, $Sky, $Floor, $Feet:  positionY
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
		$Feet.visible = 1
		
		$Feet.scale.y = (OS.window_size.y/lookingZ)*2
		#$Feet.scale.x = OS.window_size.x/$Feet.texture.get_width()*10
		$Feet.rotation_degrees = (-input_dir.x*vroll_strafe_divi)*$Feet.scale.y*2
		
		$Feet.position.y = (OS.window_size.y/$Feet.texture.get_height())  +$Feet.scale.y*5
		feetY = $Feet.position.y
		
	
	elif lookingZ > 140:
		$Feet.visible = 1
		$Feet.position.y = feetY - ((lookingZ-180)*$Feet.scale.y)
		
	
	else:
		$Feet.visible = 0
	
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
		$Feet.frame = 0
		$AnimationPlayer.stop()
	
	
	if window_size_check != OS.window_size:
		print(OS.window_size,", changed from ",window_size_check)
		window_or_texture_changed()
		
	
	if texture_change_check != [$Feet.texture, Sky.texture, Floor.texture]:
		if texture_change_check[0] != $Feet.texture:
			print("Feet texture changed")
		elif texture_change_check[1] != Sky.texture:
			print("Sky texture changed")
		elif texture_change_check[2] != Floor.texture:
			print("Floor texture changed")
		
		window_or_texture_changed()
		
	
	if rays[0].cast_to.y != draw_distance:
		print(draw_distance," horizon was ",rays[0].cast_to.y)
		
		for n in angles-1:
			rays[n].cast_to.y = draw_distance
		
		if draw_type > 0:
			draw_type2_minH = (sqrt(pow(0, 2) + pow((draw_distance), 2)) )
			sprites[angles].scale.y = OS.window_size.y/draw_type2_minH
		
	
	

#######      #######         ####         ####   ###########   ##########
###    ###   ###    ###   ###    ###   ###       ###           ###        
#######      #######      ###    ###   ###       ###########   ##########
###          ###    ###   ###    ###   ###       ###                  ###
###          ###    ###      ####         ####   ###########   ##########

################################################################################
################################################################################
################################################################################
################################################################################





var window_size_check #Things only always checking for screen_size changes
var texture_change_check     #Array checking if texture becomes different
func window_or_texture_changed():
	Sky.rect_size.y = Sky.texture.get_height()
	Sky.rect_scale.y = -(OS.window_size.y/2)/float(Sky.rect_size.y) 
	
	Sky.rect_size.x = (Sky.texture.get_width()+OS.window_size.x)*2
	Sky.rect_scale.x = (OS.window_size.x/Sky.texture.get_width())
	
	
	
	Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	
	
	$Feet.scale.y = (OS.window_size.y/180)*2
	$Feet.scale.x = OS.window_size.x/$Feet.texture.get_width()*10
	
	feetY = (OS.window_size.y/$Feet.texture.get_height())  +$Feet.scale.y*5
	
	
	window_size_check = OS.window_size
	texture_change_check = [$Feet.texture, Sky.texture, Floor.texture]
	
	
	if draw_type > 0:
		sprites[angles].scale.y = OS.window_size.y/draw_type2_minH
		sprites[angles].scale.x = OS.window_size.x*2







##############################################################################################################################################################################################

var highlighted_map_ray = (angles/2)

export var brightness = 20
export var brightMax = 255

export var line_gap_compensate = 0.3

export var draw_distance = 1000
export var draw_type = 2
export var draw_fade = 1.5
var   draw_type2_minH = 0



func _draw():
	for n in angles-1:
		if rays[n].is_colliding():
			var distance = sqrt(pow((rays[n].get_collision_point().x - position.x), 2) + pow((rays[n].get_collision_point().y - position.y), 2))
			
			var lineH = (OS.window_size.y / distance) / cos( deg_rad(rays[n].rotation_degrees) ) #Compensate fisheye with angle
			
			
			sprites[n].scale.y = lineH 
			sprites[n].position.y = (texture_cellsize) * ((-positionZ/100)*lineH)
			
			
			
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			var xkusu_next = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n+1].rotation_degrees))   )) #Position re-angled correctly
			var xkusu      = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n  ].rotation_degrees))   ))
			
			sprites[n].position.x = xkusu
			sprites[n].scale.x = (xkusu - xkusu_next - angles_mult/10)-line_gap_compensate
			
			
			
			
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			var tile_cell = Worldconfig.TileMap.get_cellv( Worldconfig.TileMap.world_to_map(rays[n].get_collision_point() - rays[n].get_collision_normal() * 0.001) )
			# Raycast collision point > Tilemap world-to-map > Tilemap get_cell ID
			
			if tile_cell == -1:
				tile_cell = 0
			
			
			
			var texture_x = abs(     rays[n].get_collision_point().x  -  (  int(rays[n].get_collision_point().x/10) *10  )     )*texture_cellsize/10
			var johncasey = 0
			
			#Only flip square walls otherwise glitches
			if (Worldconfig.TileCol.get_cellv( Worldconfig.TileCol.world_to_map(rays[n].get_collision_point() - rays[n].get_collision_normal() * 0.001) )) == 0: 
				var true_n_angle = $RayContainer.rotation_degrees + rays[n].rotation_degrees
				
				if true_n_angle > 360:
					true_n_angle -= 360
				elif true_n_angle < 0:
					true_n_angle += 360
				
				
				
				
				if texture_x == 0:
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
				
				
				
				
				else:
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
			
			
			
			
			else:
				if texture_x == 0:
					texture_x = abs(rays[n].get_collision_point().y - (int(rays[n].get_collision_point().y/10)*10))*texture_cellsize/10
			
			
			
			var checkthis = ((tile_cell*texture_cellsize) - texture_x) + texture_cellsize #something is still wrong here I just don't know what
			
			if johncasey == 1 && checkthis < (sprites[0].vframes * sprites[0].hframes):
				sprites[n].frame = checkthis#((tile_cell*texture_cellsize) - texture_x) + texture_cellsize
				# though it also seems why they're getting fuzzy close to 0,0 for some reason
			
			elif johncasey == 0:
				sprites[n].frame = (tile_cell*texture_cellsize) + texture_x # don't know why but this extra math has got to be here otherwise X walls don't render
			
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			var C = (lineH*brightness)
			if C > brightMax:
				C = brightMax 
			
			#C -= positionZ
			
			
			if draw_type == 0:
				sprites[n].self_modulate = Color8(C, C, C, 255)
			
			else:
				var Cfade = 255
				if distance > draw_distance/draw_fade:
					Cfade = brightMax/(distance-(draw_distance/draw_fade))
					
				elif abs(draw_type) == 2:
					Cfade = C#brightMax
				
				
				
				if abs(draw_type) == 1:
					sprites[n].self_modulate = Color8(C, C, C, Cfade)
				
				elif abs(draw_type) == 2:
					if ((C+Cfade)/2) < C:
						C = (C+Cfade)/2
					
					sprites[n].self_modulate = Color8(C, C, C, 255)
			
			
			#print(rays[n].get_collision_point())
			
			
			
			
			############################################################################### Show map
			if Input.is_action_pressed("ui_accept"): 
				draw_line(Vector2(0,0), rays[n].get_collision_point() - position, Color8(C,C,C), 1)
				
				
				if rays[highlighted_map_ray].is_colliding():
					draw_line(Vector2(0,0), rays[highlighted_map_ray].get_collision_point() - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 1)
				
		
		
		
		else: #draw horizon line
#			if draw_type == 2:
#				sprites[n].scale.y = OS.window_size.y/draw_type2_minH
#				sprites[n].self_modulate = Color(0,0,0)
#				
#				sprites[n].position.x = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n  ].rotation_degrees))   ))# / tan((0.5 * (angles*angles_mult)))
#				
#				var xkusu_next = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n+1].rotation_degrees))   ))# / tan((0.5 * (angles*angles_mult)))
#				var xkusu      = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n  ].rotation_degrees))   ))# / tan((0.5 * (angles*angles_mult)))
#				sprites[n].scale.x = (xkusu - xkusu_next - angles_mult/10)-line_gap_compensate
#				
#				sprites[n].position.y = (texture_cellsize) * ((-positionZ/100)*(OS.window_size.y/draw_type2_minH))
#			else:
			sprites[n].scale.y = 0
			
			
			
			############################################################################### Show map
			if Input.is_action_pressed("ui_accept"): #Show map
				if !rays[highlighted_map_ray].is_colliding():
					draw_line(Vector2(0,0), rays[highlighted_map_ray].cast_to.rotated(rotation_angle) - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 1)
					
					
	
	
	if draw_type > 0: #the black horizon wall
		sprites[angles].position.y = (texture_cellsize) * ((-positionZ/100)*(OS.window_size.y/draw_type2_minH))
	
	
	
	#Rendering scale to all fit inside screen!
	
	var get_edgy = abs(sprites[angles-3].position.x - sprites[angles-2].position.x)
	#var render_size = (sprites[0].position.x - get_edgy) - (sprites[angles-2].position.x + get_edgy)
	var render_size = (sprites[0].position.x + get_edgy) - (sprites[angles-2].position.x - get_edgy)
	
	if render_size != 0:
		#$SpriteContainer.scale.x = abs(OS.window_size.x/render_size)#+abs(lookingZ)/OS.window_size.y
		$SpriteContainer.scale.x = abs(OS.window_size.x/render_size) + lookZscale#abs(lookingZ)/OS.window_size.y
	else:
		$SpriteContainer.scale.x = 1













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
