extends KinematicBody2D

var motion = Vector2()

onready var RayContainer = $RayContainer

onready var SpriteContainer = $SpriteContainer

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
export var spritePNGx = 110
export var sprite_cellsize = 10
var sprites = []



func _ready():
	angles *= angles_divi
	angles -= 1 #removes gap between last line and screen edge, doesn't seem to cause any issue
	
	$SpriteContainer/Sprite0.hframes = spritePNGx
	
	for n in angles:
		var new_ray = $RayContainer/Ray0.duplicate()
		new_ray.rotation_degrees = ( (n/angles_divi) - (angles/angles_divi)/2 )
		RayContainer.add_child(new_ray)
		
		rays.append(new_ray)
		
	
	#for m in 1+angles:
		tile_cell.append(0)
		
		var new_sprite = $SpriteContainer/Sprite0.duplicate()
		SpriteContainer.add_child((new_sprite))
		sprites.append(new_sprite)
	
	$RayContainer/Ray0.queue_free()
	$SpriteContainer/Sprite0.queue_free()
	sprites[angles-1].queue_free()
	
	$Background.visible = 1








var rotation_angle = 0
export var rotate_rate = 1.0

export var speed = 50
var input_dir = Vector2(0,0)
var move_dir = Vector2(0,0)

var viewbob = 0
var viewbob_max = 5
var viewbob_speed = 0.1



func _physics_process(_delta):
	update()
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = Vector2(speed*move_dir.x, speed*move_dir.y).rotated(rotation_angle)
	
	
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
		else:
			move_dir.x = 0
			
			rotation_angle -= 0.0174533 * rotate_rate #1 degree in radian
			if rotation_angle < 0:
				rotation_angle = 2*PI #360 in radian
	
	
	elif Input.is_action_pressed("ui_right"):
		input_dir.x = -1
		if Input.is_action_pressed("ui_select"): #strafe
			move_dir.x = -1
		else:
			move_dir.x = 0
			
			rotation_angle += 0.0174533 * rotate_rate #1 degree in radian
			if rotation_angle > 2*PI: #360 in radian
				rotation_angle = 0
	
	
	else:
		input_dir.x = 0
		move_dir.x = 0
	
	RayContainer.rotation_degrees = rad_deg(rotation_angle) #radian to degrees
	########################################################################################################################################################
	
	
	
	#viewbob, floor & sky
	########################################################################################################################################################
	if move_dir != Vector2(0,0):
		if move_dir.y == 1:
			viewbob += viewbob_speed
		else:
			viewbob -= viewbob_speed
	
	else:
		if viewbob != 0:
			viewbob = stepify(lerp(viewbob,0,0.1),0.1)
	
	
	if viewbob > viewbob_max:
		viewbob = -viewbob_max
	elif viewbob < -viewbob_max:
		viewbob = viewbob_max
	
	
	SpriteContainer.position.y = abs(viewbob)
	
	
	Floor.position = Vector2( (-OS.window_size.x + OS.window_size.x)/2 , (OS.window_size.y/4) + abs(viewbob) )
	Floor.scale = Vector2( OS.window_size.x/100 , OS.window_size.y/200 )
	#floor is 100x100, logic for these       ^                      ^ to work 
	
	Sky.rect_size.x = OS.window_size.x*2
	Sky.rect_position = Vector2( (-OS.window_size.x/2)-RayContainer.rotation_degrees, -Sky.rect_size.y +viewbob_max)# + abs(viewbob) )
	#sky is x360, so repeating matches all rotation degrees
	########################################################################################################################################################









export var fisheye_on = 0

export var brightness = 2

func _draw():
	for n in angles-1:
		if rays[n].is_colliding():
			var distance = sqrt(pow((rays[n].get_collision_point().x - position.x), 2) + pow((rays[n].get_collision_point().y - position.y), 2))
			
			
			var lineH = 0
			
			
			var xkusu = 0
			var xkusu_next = 0
			
			if fisheye_on == 1:
				lineH = OS.window_size.y / distance #fisheye mode
				
				xkusu_next = (n+1)*(OS.window_size.x/angles) - (angles*OS.window_size.x/angles)/2
				xkusu = (n)*(OS.window_size.x/angles) - (angles*OS.window_size.x/angles)/2
				
				####Very very interesting mistake here, made for a textured floor & ceiling effect. Might be worth studying!
				#xkusu = ( (n) - angles/2 ) * (OS.window_size.x/angles/angles_divi)
				#xkusu_next = (n+1) - angles/2 * (OS.window_size.x/angles/angles_divi)
			
			else:
				lineH = (OS.window_size.y / distance) /  cos( deg_rad(rays[n].rotation_degrees) )
				
				
				xkusu_next = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n+1].rotation_degrees))   ))#/ tan(deg_rad(0.5 * (angles*angles_divi))))) 
				xkusu = (OS.window_size.x * (0.5 * tan(deg_rad(rays[n].rotation_degrees))          ))# / tan(deg_rad(0.5 * (angles*angles_divi))))) 
				############ position ################ horizontal correct ############################## anti-fisheye correction
				##### actually this might be wrong ################################################## cause removing this didn't change a thing
			
			
			
			# NO NEED FOR FIXING BROKEN CELLS, IT WAS THIS NUMBER ALL ALONG                                                       this one son of a bitch    V
			tile_cell[n] = Worldconfig.TileMap.get_cellv( Worldconfig.TileMap.world_to_map(rays[n].get_collision_point() - rays[n].get_collision_normal() * 0.001) )
			
			if tile_cell[n] == -1:
				tile_cell[n] = 0
			
			
			
			#var dir = Vector2( sign(rays[n].get_collision_point().x - position.x), sign(rays[n].get_collision_point().y - position.y) )
			#   up = -1,-1.   left = -1, 1.   down =  1, 1.   right =  1,-1.
			#right     -ok
			#up/down   -fuzzy
			#left/down -flipped but not always?
			
			###################### texture align ##############################
			var texture_x = 0
			
			texture_x = abs(rays[n].get_collision_point().x - (int(rays[n].get_collision_point().x/10)*10))
			if texture_x == 0:
				texture_x = abs(rays[n].get_collision_point().y - (int(rays[n].get_collision_point().y/10)*10))
			
			
			
			
			
			
			
			
			var C = lineH*brightness
			if C > 255:
				C = 255
			
			
			
			
			sprites[n].scale.y = lineH/2
			sprites[n].position.x = xkusu                            #Thinking we could just calculate these once at launch
			sprites[n].scale.x = xkusu - xkusu_next - angles_divi/10 #save some processing will ya
			sprites[n].frame = (tile_cell[n]*sprite_cellsize) + texture_x
			sprites[n].self_modulate = Color8(C, C, C)
			
			
			
			
			
			
			
			############################################################################### Show map
			if Input.is_action_pressed("ui_accept"): 
				draw_line(Vector2(0,0), rays[n].get_collision_point() - position, Color8(C,C,C), 1)
				
				if rays[angles/2].is_colliding():
					draw_line(Vector2(0,0), rays[angles/2].get_collision_point() - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 1)
					
				
		
		
		else: #draw horizon line
			sprites[n].scale.y = 0.1
			sprites[n].self_modulate = Color(0,0,0)
			
			############################################################################### Show map
			if Input.is_action_pressed("ui_accept"): #Show map
				if !rays[angles/2].is_colliding():
					draw_line(Vector2(0,0), rays[angles/2].cast_to.rotated(rotation_angle) - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 1)
					
					
				
			

























#					# lets try some shit, this is how you get the position ahead of a raycast hit!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#					var Numba = 0#angles/2
#					
#					draw_line(Vector2(0,0), rays[Numba].get_collision_point() - position, Color(1,1,0), 2)
#					
#					
#					var cum = deg_rad(RayContainer.rotation_degrees + rays[Numba].rotation_degrees)
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
