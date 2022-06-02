extends KinematicBody2D

var motion = Vector2()

onready var RayContainer = $RayContainer
onready var Ray0 = $RayContainer/Ray0

onready var SpriteContainer = $SpriteContainer
onready var Sprite0 = $SpriteContainer/Sprite0


export var angles = 90
export var angles_divi = 2.0
#with angles *= angles_divi
# Has to be 2, or + 1.5!   2, 3.5, 5, 6.5, 8, 9.5, 11...
# if not,
# has to be 1, 4, 7...
#something fucky going on with this variable that actually should be multiple
#I think the resolution here is tier

var rays = []
var tile_cell = []
export var spritePNGx = 176
export var sprite_cellsize = 16
var sprites = []

func _ready():
	angles *= angles_divi
	
	for n in 1+angles*angles_divi:
		var new_ray = Ray0.duplicate()
		new_ray.rotation_degrees = ( (n/angles_divi) - (angles/angles_divi)/2 )
		RayContainer.add_child(new_ray)
		
		rays.append(new_ray)
		
	
	
	Sprite0.hframes = spritePNGx
	#Sprite0.scale.x = angles_divi*3
	
	for m in 1+angles:
		tile_cell.append(0)
		
		var new_sprite = Sprite0.duplicate()
		SpriteContainer.add_child((new_sprite))
		sprites.append(new_sprite)
	
	Ray0.queue_free()
	Sprite0.queue_free()
	sprites[angles].queue_free()










var rotation_angle = 0
export var rotate_rate = 1.0

export var speed = 50
var input_dir = Vector2(0,0)
var move_dir = Vector2(0,0)

func _physics_process(_delta):
	update()
	motion = move_and_slide(motion, Vector2(0,-1))
	
	
	motion = Vector2(speed*move_dir.x, speed*move_dir.y).rotated(rotation_angle)
	#RayContainer.position = Vector2(sign(motion.x),sign(motion.y))
	
	if Input.is_action_pressed("ui_up"):
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
		if Input.is_action_pressed("ui_select"):
			move_dir.x = 1
		else:
			move_dir.x = 0
			
			rotation_angle -= 0.0174533 * rotate_rate # 1 degree in radian
			if rotation_angle < 0:
				rotation_angle = 2*PI # 360 in radian
	
	
	elif Input.is_action_pressed("ui_right"):
		input_dir.x = -1
		if Input.is_action_pressed("ui_select"):
			move_dir.x = -1
		else:
			move_dir.x = 0
			
			rotation_angle += 0.0174533 * rotate_rate # 1 degree in radian
			if rotation_angle > 2*PI: # 360 in radian
				rotation_angle = 0
	
	
	else:
		input_dir.x = 0
		move_dir.x = 0
	
	
	RayContainer.rotation_degrees = rad_deg(rotation_angle)# * 180/PI) # radian to degrees
	









#export var line_size = 4
var color

func _draw():
	for n in angles:
		if rays[0].is_colliding():
			var distance = sqrt( pow((rays[n].get_collision_point().x - position.x), 2)  +  pow((rays[n].get_collision_point().y - position.y), 2) )
			
			var lineH = (OS.get_screen_size().x / distance)  /  cos( deg_rad(rays[n].rotation_degrees) )
			
			#var xkusu = (n*line_size - angles*line_size/2) 
			#var xkusu = (n*line_size - angles*line_size/2) + (OS.get_screen_size().y * (0.5 * tan(deg_rad(rays[n].rotation_degrees)) / tan(deg_rad(0.5 * (angles*angles_divi)))))
			#var xkusu = n - angles/2 + (OS.get_screen_size().y * (0.5 * tan(deg_rad(rays[n].rotation_degrees)) / tan(deg_rad(0.5 * (angles*angles_divi))))) 
			var xkusu = (OS.get_screen_size().y * (0.5 * tan(deg_rad(rays[n].rotation_degrees)) / tan(deg_rad(0.5 * (angles*angles_divi))))) 
			var xkusu_next = (OS.get_screen_size().y * (0.5 * tan(deg_rad(rays[n+1].rotation_degrees)) / tan(deg_rad(0.5 * (angles*angles_divi))))) 
			############ position #### horizontal correct #### anti-fisheye correction
			
			
			
			
			tile_cell[n] = Worldconfig.TileMap.get_cellv( Worldconfig.TileMap.world_to_map(rays[n].get_collision_point() - rays[n].get_collision_normal() * 1) )
			
			if tile_cell[n] == -1:
				fixcell(n)
			
			
			########################################### color only mode ##################
			#pickcolor(lineH, n)
			#draw_line(Vector2(xkusu, lineH), Vector2(xkusu, -lineH), color, line_size)
			##############################################################################
			################################### 1 pix texture ############################
			var C = lineH*brightness
			if C > 255:
				C = 255
			
			sprites[n].position.x = xkusu
			sprites[n].scale.y = lineH/15
			sprites[n].scale.x = xkusu - xkusu_next - angles_divi/10
			sprites[n].self_modulate = Color8(C, C, C)
			#sprites[n].frame = tile_cell[n]*sprite_cellsize 
			
			var texture_x = 0
			var dir = Vector2( sign(rays[n].get_collision_point().x - rays[n].global_position.x), sign(rays[n].get_collision_point().y - rays[n].global_position.y) )
			#   up = -1,-1.   left = -1, 1.   down =  1, 1.   right =  1,-1.
			
			##################################################################### FAILS DON'T TRY THESE ###############################################################################################
			#if dir.x == dir.y: #Vertical
				#texture_x = abs(rays[n].get_collision_point().y) - round(abs(rays[n].get_collision_point().y))                          #no good
				#texture_x = (stepify(abs(rays[n].get_collision_point().y),0.01) - stepify(abs(rays[n].get_collision_point().y),1)) *100 #no good!
				#texture_x = ( rays[n].get_collision_point().y - stepify(rays[n].get_collision_point().y,1 ) )                           #no good!!
				#texture_x = ( rays[n].get_collision_point().y - stepify(rays[n].get_collision_point().y,1) )/sprite_cellsize            #no good!!! where the fuck did I put the only decent one??
			#else:
				#texture_x = abs(rays[n].get_collision_point().x) - round(abs(rays[n].get_collision_point().x))
				#texture_x = (stepify(abs(rays[n].get_collision_point().x),0.01) - stepify(abs(rays[n].get_collision_point().x),1)) *100
				#texture_x = ( rays[n].get_collision_point().x - stepify(rays[n].get_collision_point().x,1 ) )#/sprite_cellsize
				#texture_x = ( rays[n].get_collision_point().x - stepify(rays[n].get_collision_point().x,1) )/sprite_cellsize
			#############################################################################################################################################################################################
			# KINDA GOOD
			#texture_x = rays[n].get_collision_point().y
			
			
			
			#if dir.x == dir.y: #Vertical
			#	texture_x = abs( rays[n].get_collision_point().y - (int(rays[n].get_collision_point().y/10)*10) )
				
			#else:
			
			
			
			texture_x = abs(rays[n].get_collision_point().x - (int(rays[n].get_collision_point().x/10)*10))
			
			if n == 120:
				print(
				round(rays[n].get_collision_point().x),"   ",
				rays[n].get_collision_point().x / 10,"   ",
				int(rays[n].get_collision_point().x / 10)*10,"    ",
				round(rays[n].get_collision_point().x) - int(rays[n].get_collision_point().x / 10)*10
				)
			
			
			
			sprites[n].frame = (tile_cell[n]*sprite_cellsize) + texture_x
			
			
			
			
			
			
			##############################################################################
			#if Input.is_action_pressed("ui_accept"): #Debug stuff
			#	pickcolor(lineH, n)
			#	draw_line(Vector2(0,0), rays[n].get_collision_point() - position, color, 1) #rays_array[n].get_collision_point() - position, color, 1)
		
			if Input.is_action_pressed("ui_accept"): #Debug stuff
				color = Color(randi() % 2,randi() % 2,randi() % 2)
				draw_line(Vector2(0,0), rays[120].get_collision_point() - position, color, 1)







func fixcell(n): # How about we try picking the closest position with a valid cell? try doing that later 
	var tile_back
	var tile_front
	
	var back_lineH = 0
	var front_lineH = 0
	
	
	for a in angles/2:
		if tile_cell[n-a] != -1: 
			tile_back = tile_cell[n-a]
			back_lineH = OS.get_screen_size().x/sqrt(pow( ((rays[n-a].get_collision_point() - rays[n-a].get_collision_normal()).x - position.x), 2) + pow(((rays[n-a].get_collision_point() - rays[n-a].get_collision_normal()).y - position.y), 2) )
			break
	
	for b in angles/2:
		if tile_cell[n+b] != -1:
			tile_front = tile_cell[n+b]
			front_lineH = OS.get_screen_size().x/sqrt(pow(((rays[n+b].get_collision_point() - rays[n+b].get_collision_normal()).x - position.x), 2) + pow(((rays[n+b].get_collision_point() - rays[n+b].get_collision_normal()).y - position.y), 2))
			break
	
	
	if back_lineH > front_lineH:
		tile_cell[n] = tile_back
		pickcolor(back_lineH, n)
	else:
		tile_cell[n] = tile_front
		pickcolor(front_lineH, n)
	
	return










export var brightness = 2

func pickcolor(lineH, n):
	var C = lineH*brightness
	
	if tile_cell[n] == 1:# []  square
		color = Color8(0,C,0)# green
	
	elif tile_cell[n] == 2:# \|
		color = Color8(0,0,C)# blue
	
	elif tile_cell[n] == 3:# |\
		color = Color8(C,0,C)# pink
	
	elif tile_cell[n] == 4:# /|
		color = Color8(0,C,C)# light blue
	
	elif tile_cell[n] == 5:# |/
		color = Color8(C,C,0)# yellow
	
	elif tile_cell[n] == 6:# []  square2
		color = Color8(C,C,C)# white
	
	elif tile_cell[n] == 7:# -  dot/pole
		color = Color8(C/10,C/10,C)# blue shadow
	
	elif tile_cell[n] == 8:# X
		color = Color8(C/10,0,0)# dark red
	
	elif tile_cell[n] == 9:# O 
		color = Color8(0,C*5,C*5)# bright blue
	
	elif tile_cell[n] == 10:# : :  sides
		color = Color8(C/2,C/4,C/6)# headache









func rad_deg(N):
	N *= 180/PI
	return N

func deg_rad(N):
	N *= PI/180
	return N
