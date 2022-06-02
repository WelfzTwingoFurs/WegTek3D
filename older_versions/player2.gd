extends KinematicBody2D

	#print("\nX: ", abs(Ray0.get_collision_point().x - position.x)/gridsize, "\nY: ",abs(Ray0.get_collision_point().y - position.y)/gridsize)
	#print(position,"\n",Ray0.get_collision_point(),"\n",position-Ray0.get_collision_point(),"\n")

export var _TEXTURE_PATH = "res://tiles.png"



var motion = Vector2()
const SPEED = 100

onready var RayContainer = $RayContainer
onready var Ray0 = $RayContainer/Ray0
var rays_array = []
var tile_cell = []
var tile_pos = []

export var angles = 90


func _ready():
	for n in angles+1:
		var new_ray = Ray0.duplicate()
		new_ray.rotation_degrees = n-angles/2 #angle-counter - amount-of-angles/2
		RayContainer.add_child(new_ray)
		
		rays_array.append(new_ray)
		tile_cell.append(n)
		tile_pos.append(Vector2(0,0))





var main_rotation = 0
export var rotate_rate = 1.0

var input_dir = Vector2(0,0)

func _physics_process(_delta):
	update()
	motion = move_and_slide(motion, Vector2(0,-1))
	
	
	if Input.is_action_pressed("ui_up"):
		motion = Vector2(0, SPEED).rotated(main_rotation)
		input_dir.y = -1
	
	elif Input.is_action_pressed("ui_down"):
		motion = Vector2(0, -SPEED).rotated(main_rotation)
		input_dir.y = 1
	
	else:
		motion = Vector2(0,0)
		input_dir.y = 0
	
	
	if Input.is_action_pressed("ui_left"):
		main_rotation -= 0.0174533 * rotate_rate # 1 degree in radian
		
		if main_rotation < 0:
			main_rotation = 2*PI # 360 in radian
		input_dir.x = -1
	
	elif Input.is_action_pressed("ui_right"):
		main_rotation += 0.0174533 * rotate_rate # 1 degree in radian
		
		if main_rotation > 2*PI: # 360 in radian
			main_rotation = 0
		input_dir.x = 1
	else:
		input_dir.x = 0
	
	
	RayContainer.rotation_degrees = (main_rotation * 180/PI) # radian to degrees



export var lines_spacing = 4

export var fixeye = 1
export var fixtiles = 1
export var fixbadcell = 1
export var polywalls = 0
export var polyfixblocky = 1



export var brightness = 2

export var gridsize = 16

var color = Color(0,0,0)



func _draw():
	for n in angles:
		if Input.is_action_pressed("ui_accept"):
			draw_line(Vector2(0,0), rays_array[n].get_collision_point() - position, color, 1) #rays_array[n].get_collision_point() - position, color, 1)
			$Sprite.visible = 1
		elif !Input.is_action_pressed("ui_accept"):
			$Sprite.visible = 0
		
		
		if rays_array[n].is_colliding():
			var distance = sqrt(pow((rays_array[n].get_collision_point().x - position.x), 2) + pow((rays_array[n].get_collision_point().y - position.y), 2))
			
			
			
			
			if fixtiles == 1:
				tile_pos[n] = Worldconfig.TileMap.world_to_map( rays_array[n].get_collision_point() - rays_array[n].get_collision_normal() * 1 )
			
			elif fixtiles == 2:
				var dir = Vector2( sign(rays_array[n].get_collision_point().x - rays_array[n].global_position.x), sign(rays_array[n].get_collision_point().y - rays_array[n].global_position.y) )
				
				if dir == Vector2(-1,-1):
					tile_pos[n] = Worldconfig.TileMap.world_to_map( Vector2(rays_array[n].get_collision_point().x -1, rays_array[n].get_collision_point().y -1) )
				else:
					if dir.x == -1:
						tile_pos[n] = Worldconfig.TileMap.world_to_map( Vector2(rays_array[n].get_collision_point().x -1, rays_array[n].get_collision_point().y) )
					elif dir.y == -1:
						tile_pos[n] = Worldconfig.TileMap.world_to_map( Vector2(rays_array[n].get_collision_point().x, rays_array[n].get_collision_point().y -1) )
					else:
						tile_pos[n] = Worldconfig.TileMap.world_to_map( rays_array[n].get_collision_point() )
			
			else:
				tile_pos[n] = Worldconfig.TileMap.world_to_map( rays_array[n].get_collision_point() )
			
			
			
			
			tile_cell[n] = Worldconfig.TileMap.get_cellv( tile_pos[n] )
			
			if tile_cell[n] == -1:
				if fixbadcell == 1:
					tile_cell[n] = tile_cell[n+1]
					
				elif fixbadcell == 2:
					fixcell(n)
					
			
			
			
			
			if fixeye == 1:
				distance *= cos(rays_array[n].rotation_degrees * (PI/ (angles*2) ))# 90o
				
			elif fixeye == 2:
				distance *= cos(rays_array[n].rotation_degrees * (PI / angles/1.5))
				#print(120/1.5,",  ",140/1.3)
				
				#var coom = ((lines_spacing/2*0.1)+1) #2= 90, 1.5 = 120,  1.3 140
				#distance *= cos(rays_array[n].rotation_degrees * (PI / (angles/coom) ))
			
			
			
			var lineH = OS.get_screen_size().x/distance
			if (lineH > OS.get_screen_size().x):
				lineH = OS.get_screen_size().x
			
			
			
			var xkusu = n*lines_spacing - angles*lines_spacing/2
			
			if polywalls == 0:
				pickcolor(lineH,n)
				draw_line(Vector2(xkusu, lineH), Vector2(xkusu, -lineH), color, lines_spacing)
			
			else:
				var distance2 = sqrt(pow((rays_array[n+1].get_collision_point().x - position.x), 2) + pow((rays_array[n+1].get_collision_point().y - position.y), 2))
				
				if fixeye == 1:
					distance2 *= cos(rays_array[n].rotation_degrees * (PI/ (angles*2) ))# 90o
				elif fixeye == 2:
					distance2 *= cos(rays_array[n].rotation_degrees * (PI / angles/1.5))
				
				
				var lineH2 = OS.get_screen_size().x/distance2
				if (lineH2 > OS.get_screen_size().x):
					lineH2 = OS.get_screen_size().x
				
				
				var xkusu2 = (n+1)*lines_spacing - angles*lines_spacing/2
				
				
				pickcolor(lineH,n)
				
				if tile_cell[n] == tile_cell[n+1]  &&  ( (tile_pos[n] - tile_pos[n+1]).abs() < Vector2(1,1) ):
					draw_polygon([Vector2(xkusu, lineH), Vector2(xkusu, -lineH), Vector2(xkusu2, -lineH2), Vector2(xkusu2, lineH2)], [color])
				
				else:
					if polyfixblocky == 0:
						draw_polygon([Vector2(xkusu, lineH), Vector2(xkusu, -lineH), Vector2(xkusu2, -lineH), Vector2(xkusu2, lineH)], [color])
						
					else:
						var lineHminus
						
						if polyfixblocky == 1:
							lineHminus = (sqrt(pow((rays_array[n-1].get_collision_point().x - position.x), 2) + pow((rays_array[n-1].get_collision_point().y - position.y), 2)))
						
						elif polyfixblocky == 2:
							lineHminus = (sqrt(pow((rays_array[n+input_dir.x*rotate_rate -1].get_collision_point().x - position.x), 2) + pow((rays_array[n+input_dir.x*rotate_rate -1].get_collision_point().y - position.y), 2)))
						
						
						if fixeye == 1:
							lineHminus *= cos(rays_array[n].rotation_degrees * (PI / angles/2))
						elif fixeye == 2:
							lineHminus *= cos(rays_array[n].rotation_degrees * (PI / angles/1.5))
						
						
						if (lineHminus > OS.get_screen_size().x):
							lineHminus = OS.get_screen_size().x
						
						
						
						var failangle = lineH - OS.get_screen_size().x/lineHminus
						
						if Geometry.triangulate_polygon([Vector2(xkusu, lineH), Vector2(xkusu, -lineH), Vector2(xkusu2, -lineH-failangle), Vector2(xkusu2, lineH+failangle)]).empty():
							draw_polygon([Vector2(xkusu, lineH), Vector2(xkusu, -lineH), Vector2(xkusu2, -lineH), Vector2(xkusu2, lineH)], [color])
						else:
							draw_polygon([Vector2(xkusu, lineH), Vector2(xkusu, -lineH), Vector2(xkusu2, -lineH-failangle), Vector2(xkusu2, lineH+failangle)], [color])
					
				
				
				
				
				
				
			##################################################### Top-down view ####
			#draw_line(rays_array[n].get_collision_point(),
			#		  rays_array[n+1].get_collision_point(), Color8(255, 255, 0), 1)








func fixcell(n):
	var tile_back
	var tile_front
	
	var back_lineH= 0
	var front_lineH= 0
	
	
	
	for a in (angles)/2:
		if tile_cell[n-a] != -1:
			tile_back = tile_cell[n-a]
			back_lineH = OS.get_screen_size().x/sqrt(pow( (rays_array[n-a].get_collision_point().x - position.x), 2) + pow((rays_array[n-a].get_collision_point().y - position.y), 2) )
			
			if (back_lineH > OS.get_screen_size().x):
				back_lineH = OS.get_screen_size().x
			break
	
	for b in (angles)/2:
		if tile_cell[n+b] != -1:
			tile_front = tile_cell[n+b]
			front_lineH = OS.get_screen_size().x/sqrt(pow((rays_array[n+b].get_collision_point().x - position.x), 2) + pow((rays_array[n+b].get_collision_point().y - position.y), 2))
			
			if (front_lineH > OS.get_screen_size().x):
				front_lineH = OS.get_screen_size().x
			break
	
	
	if back_lineH > front_lineH:
		tile_cell[n] = tile_back
	else:
		tile_cell[n] = tile_front
	
	return







func pickcolor(lineH,n):
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
		color = Color8(0,lineH*brightness*3,lineH*brightness*5)# bright blue
	
	elif tile_cell[n] == 10:# : :  sides
		color = Color8(C*main_rotation/2,C*main_rotation/4,C*main_rotation/6)# headache
	
	else:
		pass#color = Color(0,0,0)






#		$RaySingle.rotation_degrees = (main_rotation * 180 / 3.14) + (n * 180 / 3.14)
#		var distance = sqrt(pow($RaySingle.get_collision_point().x - position.x, 2) + pow($RaySingle.get_collision_point().y - position.y, 2))#get position


#		var fixeye = (RayContainer.rotation_degrees - rays_array[n].rotation_degrees) * PI/180
#		#var fixeye = (RayContainer.rotation_degrees - angles/2) * PI/180
#		if fixeye < 0:
#			fixeye += 2*PI
#		if fixeye > 2*PI:
#			fixeye -= 2*PI
		
		#var distance = sqrt(pow((rays_array[n].get_collision_point().x - position.x)*cos(fixeye), 2) + pow((rays_array[n].get_collision_point().y - position.y)*sin(fixeye), 2)) 
		#distance *= cos((rays_array[n].rotation_degrees - RayContainer.rotation_degrees) * (PI/180))
		#distance *= (RayContainer.rotation_degrees - angles/2)
		#cos(to_radians(theta - player_angle))
		
		#draw_line(Vector2(xkusu, lineH), Vector2(xkusu, -lineH), Color8(0, 255-distance/brightness, 0), lines_spacing-1)
		
		#rays_array[n].cast_to.y = OS.get_screen_size().x/2
		########################################################################



