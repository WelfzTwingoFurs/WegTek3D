extends KinematicBody2D

var motion = Vector2()

onready var Floor = $Background/Floor
onready var Sky = $Background/Sky

export var angles = 120
export var angles_divi = 2.0
#with angles *= angles_divi
# 1, 2, 4, 5, 7
# works if angles & angles_divi not divideable by 3
# however, if it is, angles & angles_divi have to be divideable by 3

var rays = []
var tile_cell = []
var sprites = []

var texture_width = 220
var texture_cellsize = 20

export var skycolor = Color8(47,0,77)

func _ready():
	VisualServer.set_default_clear_color(skycolor)
	
	texture_width = $SpriteContainer/Sprite0.texture.get_width()
	
	texture_cellsize = texture_width/10
	print(texture_width,"!   ",texture_width/10,"      ",texture_cellsize)
	
#	texture_cellsize = texture_width - (texture_width/100)*100
#	print(texture_width," -  ",(texture_width/100)*100 ,"      ",texture_cellsize)
	
	$SpriteContainer.scale.y = float(10)/texture_cellsize
	
	
	
	
	
	
	
	
	
	angles *= angles_divi
	#removes gap between last line and screen edge, doesn't seem to cause any issue
	#angles -= 1 #
	#angles += 1
	
	$SpriteContainer/Sprite0.hframes = texture_width
	
	for n in angles:
		var new_ray = $RayContainer/Ray0.duplicate()
		new_ray.rotation_degrees = ( (n/angles_divi) - (angles/angles_divi)/2 )
		$RayContainer.add_child(new_ray)
		
		rays.append(new_ray)
		
	
	#for m in 1+angles:
		tile_cell.append(0)
		
		var new_sprite = $SpriteContainer/Sprite0.duplicate()
		$SpriteContainer.add_child((new_sprite))
		sprites.append(new_sprite)
	
	$RayContainer/Ray0.queue_free()
	$SpriteContainer/Sprite0.queue_free()
	sprites[angles-1].queue_free()
	
	$Background.visible = 1
	$SpriteContainer.visible = 1
	$RayContainer.visible = 0
	
	
	$Feet.visible = 1
	$Feet.scale = Vector2(OS.window_size.x/$Feet.texture.get_width()*10, (OS.window_size.y/180)*2)
	$Feet.position.y = (OS.window_size.y/$Feet.texture.get_height())  +$Feet.scale.y*5
	feetY = $Feet.position.y






var rotation_angle = 0
export var rotate_rate = 1.0

export var speed = 50
var input_dir = Vector2(0,0)
var move_dir = Vector2(0,0)

var vbob = 0
export var vbob_max = 5.0
export var vbob_speed = 0.1

export var vroll_multi = -1.0
var vroll_strafe_divi = 1

export var sky_stretch = Vector2(0,1)



var motionZ = 0
const GRAVITY = 1
const JUMP = -10

var positionZ = 0.1

var lookingZ = 0
var lookZscale = 0
export var lookZscaling = 0.5

var feetY = 0

func _physics_process(_delta):
	update()
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = Vector2(speed*move_dir.x, speed*move_dir.y).rotated(rotation_angle)
	
	
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
	
	
	if Input.is_action_pressed("ply_jump"):# && positionZ > -32:
		positionZ -= 1
	elif Input.is_action_pressed("ply_crouch"):# && positionZ < 32:
		positionZ += 1

	elif Input.is_action_pressed("ply_flycenter"):
		#positionZ = 0
		positionZ = lerp(positionZ, 0, 0.1)
	
	
	#print(lookingZ)
	
	if Input.is_action_pressed("ply_lookup"):
		if lookingZ > -360:
			lookingZ -= rotate_rate
	elif Input.is_action_pressed("ply_lookdown"):
		if lookingZ < 360:
			lookingZ += rotate_rate
	
	elif Input.is_action_pressed("ply_lookcenter"):
		lookingZ = lerp(lookingZ, 0, 0.1)
	
	
	
	#var posZ_lookZ = -positionZ -lookingZ/$SpriteContainer.scale.y
	var posZ_lookZ = -OS.window_size.y*(positionZ/1000)  -OS.window_size.y*(lookingZ/100)
	
	lookZscale = (abs(lookingZ)*lookZscaling/OS.window_size.y)
	
	#print(positionZ,"   ",lookingZ)
	
	
	# Inputs & motion, rotation
	########################################################################################################################################################
	if Input.is_action_pressed("ui_up"): #view bob V
		input_dir.y = 1
		move_dir.y = 1
	
	
	elif Input.is_action_pressed("ui_down"):
		input_dir.y = -1
		move_dir.y = -1
	
	
	else:
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
	
	
	else:
		input_dir.x = 0
		move_dir.x = 0
	
	
	
	$RayContainer.rotation_degrees = rad_deg(rotation_angle) #radian to degrees
	########################################################################################################################################################
	
	
	
	#vbob, floor & sky
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
	Sky.rect_size.x = Sky.texture.get_width()*2#OS.window_size.x*2 
	Sky.rect_size.y = Sky.texture.get_height()
	
	
	
	if sky_stretch.x == 1:
		Sky.rect_position.x = (-OS.window_size.x/2) - ( $RayContainer.rotation_degrees*(float(OS.window_size.x)/360) ) 
		Sky.rect_scale.x = (OS.window_size.x/Sky.texture.get_width()) 
		
		#if $RayContainer.rotation_degrees > 180:
		#	Sky.flip_h = 1
		#else:
		#	Sky.flip_h = 0
	else:
		Sky.rect_position.x = (-OS.window_size.x/2) - ( $RayContainer.rotation_degrees*(float(Sky.texture.get_width())/360) ) 
		Sky.rect_scale.x = 1 
		Sky.flip_h = 0
		
	if sky_stretch.y == 1:
		Sky.rect_scale.y = -(OS.window_size.y/2)/float(Sky.rect_size.y) 
		Sky.rect_position.y = (Sky.rect_size.y  /OS.window_size.y) + abs(vbob) +vbob_max +posZ_lookZ
		Sky.flip_v = 1
		
	else:
		Sky.rect_scale.y = 1
		Sky.rect_position.y = -Sky.rect_size.y + abs(vbob) +vbob_max +posZ_lookZ
		Sky.flip_v = 0
	########################################################################################################################################################
	
	
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	#vroll
	$SpriteContainer.position.y = abs(vbob) +posZ_lookZ
	$SpriteContainer.rotation_degrees = lerp($SpriteContainer.rotation_degrees, (-input_dir.x*vroll_multi),00.1)/vroll_strafe_divi
	$Background.rotation_degrees = $SpriteContainer.rotation_degrees
	
	
	
	########################################################################################################################################################
	Floor.position.y = (OS.window_size.y) + abs(vbob) +posZ_lookZ
	Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	
	if sign(Floor.position.y/OS.window_size.y) < 0:
		VisualServer.set_default_clear_color(Floor.modulate)
	else:
		VisualServer.set_default_clear_color(skycolor)
	
	
	########################################################################################################################################################
	########################################################################################################################################################
	#feet when looking down
	
	
	if lookingZ > 180:
		$Feet.visible = 1
		
		$Feet.position.y = (OS.window_size.y/$Feet.texture.get_height())  +$Feet.scale.y*5
		feetY = $Feet.position.y
		$Feet.scale.y = (OS.window_size.y/lookingZ)*2
		
		
		$Feet.scale.x = OS.window_size.x/$Feet.texture.get_width()*10
		$Feet.rotation_degrees = (-input_dir.x*vroll_strafe_divi)*$Feet.scale.y*2
		#$Feet.rotation_degrees = -input_dir.x*vroll_strafe_divi
		
	
	elif lookingZ > 140:
		$Feet.visible = 1
		#$Feet.position.y = feetY - (lookingZ-180)*5
		$Feet.position.y = feetY - ((lookingZ-180)*$Feet.scale.y)
		
	
	else:
		$Feet.visible = 0
	########################################################################################################################################################
	
	
	
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
	########################################################################################################################################################

	if positionZ == 0:
		positionZ = 0#.1
















##############################################################################################################################################################################################

export var brightness = 20
export var brightMax = 255

export var line_gap_compensate = 0.3


func _draw():
	var highlighted_map_ray = (angles/2)
	
	for n in angles-1:
		if rays[n].is_colliding():
			var distance = sqrt(pow((rays[n].get_collision_point().x - position.x), 2) + pow((rays[n].get_collision_point().y - position.y), 2)) 
			
			var lineH = (OS.window_size.y / distance) /  cos( deg_rad(rays[n].rotation_degrees) ) #/ (float(10)/texture_cellsize)
			
			
			sprites[n].scale.y = lineH #/texture_cellsize
			
			
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			var xkusu_next = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n+1].rotation_degrees))   ))# / tan((0.5 * (angles*angles_divi)))
			var xkusu      = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n  ].rotation_degrees))   ))# / tan((0.5 * (angles*angles_divi)))
			
			sprites[n].position.x = xkusu
			
			
			sprites[n].scale.x = (xkusu - xkusu_next - angles_divi/10)-line_gap_compensate
			# this needs fixing still too
			
			
			
			#sprites[n].position.y = -positionZ*lineH -lookingZ*$SpriteContainer.scale.y
			sprites[n].position.y = -positionZ*lineH #-lookingZ*$SpriteContainer.scale.y
			
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			tile_cell[n] = Worldconfig.TileMap.get_cellv( Worldconfig.TileMap.world_to_map(rays[n].get_collision_point() - rays[n].get_collision_normal() * 0.001) )
			
			if tile_cell[n] == -1:
				tile_cell[n] = 0
			
			
			
			var texture_x = abs(rays[n].get_collision_point().x - (int(rays[n].get_collision_point().x/10)*10))*texture_cellsize/10
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
			
			
			
			var checkthis = ((tile_cell[n]*texture_cellsize) - texture_x) + texture_cellsize #something is still wrong here I just don't know what
			
			if johncasey == 1 && checkthis < (sprites[0].vframes * sprites[0].hframes):
				sprites[n].frame = checkthis#((tile_cell[n]*texture_cellsize) - texture_x) + texture_cellsize
				# though it also seems why they're getting fuzzy close to 0,0 for some reason
			
			elif johncasey == 0:
				sprites[n].frame = (tile_cell[n]*texture_cellsize) + texture_x # don't know why but this extra math has got to be here otherwise X walls don't render
			
			
			###################################################################################################################################################
			###################################################################################################################################################
			###################################################################################################################################################
			
			var C = lineH*brightness
			if C > brightMax:
				C = brightMax
			
			
			sprites[n].self_modulate = Color8(C, C, C)
			
			
			
			
			
			
			
			############################################################################### Show map
			if Input.is_action_pressed("ui_accept"): 
				draw_line(Vector2(0,0), rays[n].get_collision_point() - position, Color8(C,C,C), 1)
				
				
				if rays[highlighted_map_ray].is_colliding():
					draw_line(Vector2(0,0), rays[highlighted_map_ray].get_collision_point() - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 1)
				
		
		
		
		else: #draw horizon line
			sprites[n].scale.y = 0#.006
			#sprites[n].self_modulate = Color(0,0,0)
			
			
			############################################################################### Show map
			if Input.is_action_pressed("ui_accept"): #Show map
				if !rays[highlighted_map_ray].is_colliding():
					draw_line(Vector2(0,0), rays[highlighted_map_ray].cast_to.rotated(rotation_angle) - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 1)
					
					
	
	
	
	#Rendering scale to all fit inside screen!
	
	var get_edgy = abs(sprites[angles-3].position.x - sprites[angles-2].position.x)
	#var render_size = (sprites[0].position.x - get_edgy) - (sprites[angles-2].position.x + get_edgy)
	var render_size = (sprites[0].position.x + get_edgy) - (sprites[angles-2].position.x - get_edgy)
	
	if render_size != 0:
		#$SpriteContainer.scale.x = abs(OS.window_size.x/render_size)#+abs(lookingZ)/OS.window_size.y
		$SpriteContainer.scale.x = abs(OS.window_size.x/render_size) + lookZscale#abs(lookingZ)/OS.window_size.y
	else:
		$SpriteContainer.scale.x = 1





#fuck fuck fuck fuck
#		#$Feet.position.y = (abs(vbob) -lookingZ) + (OS.window_size.y/2) + $Feet.texture.get_height()
#		#$Feet.position.y = (abs(vbob) -lookingZ) + (OS.window_size.y/2) + 200#$Feet.texture.get_height()
#		$Feet.position.y = -lookingZ + abs(vbob) #+ (OS.window_size.y/$Feet.texture.get_())
#		$Feet.position.y = 0#-lookingZ + abs(vbob) #+ (OS.window_size.y/$Feet.texture.get_())
#		#$Feet.scale.y = (lookingZ)/$Feet.texture.get_height()
#		$Feet.scale.y = (720/lookingZ)
















#			var dir = Vector2( sign(rays[n].get_collision_point().x - position.x), sign(rays[n].get_collision_point().y - position.y) )
#			#   up = -1,-1.   left = -1, 1.   down =  1, 1.   right =  1,-1.
#			#right     -ok
#			#up/down   -fuzzy
#			#left/down -flipped but not always?



#					# lets try some shit, this is how you get the position ahead of a raycast hit!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
