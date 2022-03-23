extends KinematicBody2D

var motion = Vector2()

onready var RayContainer = $RayContainer
onready var Ray0 = $RayContainer/Ray0

onready var SpriteContainer = $SpriteContainer
onready var Sprite0 = $SpriteContainer/Sprite0


export var angles = 120
export var angles_divi = 2.0
#with angles *= angles_divi
# Has to be 2, or + 1.5!   2, 3.5, 5, 6.5, 8, 9.5, 11...
# if not,
# has to be 1, 4, 7...
#something fucky going on with this variable that actually should be multiple
#I think the resolution here is tier

var rays = []
var tile_cell = []
export var spritePNGx = 110
export var sprite_cellsize = 10
var sprites = []

func _ready():
	angles *= angles_divi
	
	for n in 1+angles*angles_divi:
		var new_ray = Ray0.duplicate()
		new_ray.rotation_degrees = ( (n/angles_divi) - (angles/angles_divi)/2 )
		RayContainer.add_child(new_ray)
		
		rays.append(new_ray)
		
	
	
	Sprite0.hframes = spritePNGx
	
	
	for m in 1+angles:
		tile_cell.append(0)
		
		var new_sprite = Sprite0.duplicate()
		SpriteContainer.add_child((new_sprite))
		sprites.append(new_sprite)
	
	Ray0.queue_free()
	Sprite0.queue_free()
	sprites[angles].queue_free()





func rad_deg(N):
	N *= 180/PI
	return N

func deg_rad(N):
	N *= PI/180
	return N






var rotation_angle = 0
export var rotate_rate = 1.0

export var speed = 50
var input_dir = Vector2(0,0)
var move_dir = Vector2(0,0)

var viewbob = 0
var viewbob_max = 5

func _physics_process(_delta):
	update()
	motion = move_and_slide(motion, Vector2(0,-1))
	
	motion = Vector2(speed*move_dir.x, speed*move_dir.y).rotated(rotation_angle)
	
	
	
	if Input.is_action_pressed("ui_up"):
		input_dir.y = 1
		move_dir.y = 1
		
		viewbob += 0.25
	
	elif Input.is_action_pressed("ui_down"):
		input_dir.y = -1
		move_dir.y = -1
		
		viewbob -= 0.25
	
	else:
		input_dir.y = 0
		move_dir.y = 0
		
		if viewbob > 0:
			viewbob -= 1
		elif viewbob < 0:
			viewbob += 1
	
	
	
	if viewbob > viewbob_max:
		viewbob = -viewbob_max
	elif viewbob < -viewbob_max:
		viewbob = viewbob_max
	
	
	
	
	
	
	
	
	
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
	









#export var line_size = 4
export var brightness = 2

func _draw():
	for n in angles:
		if rays[n].is_colliding():
			var distance = sqrt( pow((rays[n].get_collision_point().x - position.x), 2)  +  pow((rays[n].get_collision_point().y - position.y), 2) )
			
			
			var lineH = (OS.get_screen_size().x / distance)  /  cos( deg_rad(rays[n].rotation_degrees) )
			
			var xkusu_next = (OS.get_screen_size().y * (0.5 * tan(deg_rad(rays[n+1].rotation_degrees)) / tan(deg_rad(0.5 * (angles*angles_divi))))) 
			var xkusu = (OS.get_screen_size().y * (0.5 * tan(deg_rad(rays[n].rotation_degrees)) / tan(deg_rad(0.5 * (angles*angles_divi))))) 
			############ position ################ horizontal correct ############################## anti-fisheye correction
			
			
			tile_cell[n] = Worldconfig.TileMap.get_cellv( Worldconfig.TileMap.world_to_map(rays[n].get_collision_point() - rays[n].get_collision_normal() * 1) )
			
			if tile_cell[n] == -1:
				fixcell(n)
			
			
			
			###################### texture align ##############################
			var texture_x = 0
			var dir = Vector2( sign(rays[n].get_collision_point().x - rays[n].global_position.x), sign(rays[n].get_collision_point().y - rays[n].global_position.y) )
			#   up = -1,-1.   left = -1, 1.   down =  1, 1.   right =  1,-1.
			#right     -ok
			#up/down   -fuzzy
			#left/down -flipped
			
			#if dir.x == dir.y:
			texture_x = abs(rays[n].get_collision_point().x - (int(rays[n].get_collision_point().x/10)*10))
			if texture_x == 0:
				texture_x = abs(rays[n].get_collision_point().y - (int(rays[n].get_collision_point().y/10)*10))
			
			
			#else:
			#texture_x = abs(rays[n].get_collision_point().y - (int(rays[n].get_collision_point().y/10)*10))
			#if texture_x == 0:
			#	texture_x = abs(rays[n].get_collision_point().x - (int(rays[n].get_collision_point().x/10)*10))
			
			#if n == 123:
			#	print(dir)
			
			var C = lineH*brightness
			if C > 255:
				C = 255
			
			
			sprites[n].position.x = xkusu
			sprites[n].position.y = abs(viewbob)
			sprites[n].scale.y = lineH/15
			sprites[n].scale.x = xkusu - xkusu_next - angles_divi/10
			sprites[n].self_modulate = Color8(C, C, C)
			sprites[n].frame = (tile_cell[n]*sprite_cellsize) + texture_x
			#sprites[n].frame = tile_cell[n]*sprite_cellsize                    #1 pix texture
			
			
			
			
			
			##############################################################################
			if Input.is_action_pressed("ui_accept"): #Show map
				if n == angles/2:
					draw_line(Vector2(0,0), rays[n].get_collision_point() - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 2)
				else:
					draw_line(Vector2(0,0), rays[n].get_collision_point() - position, Color8(C,C,C), 1)
		
		else:
			sprites[n].position.y = abs(viewbob)
			sprites[n].scale.y = 0.1
			sprites[n].self_modulate = Color(0,0,0)
			
			if !rays[angles/2].is_colliding():
				if Input.is_action_pressed("ui_accept"): #Show map
					draw_line(Vector2(0,0), rays[angles/2].cast_to.rotated(rotation_angle) - position, Color((randi() % 2),(randi() % 2),(randi() % 2)), 2)











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
	
	#return
	#print("tb:",tile_back," bl:", back_lineH," tf:", tile_front," fl:", front_lineH)
	
	if back_lineH > front_lineH:
		tile_cell[n] = tile_back
	else:
		tile_cell[n] = tile_front
	
	return

























func fixcell2(n):
	var ray_minus
	var ray_plus
	
	var A
	var B
	
	
	for a in angles/2:
		if tile_cell[n-a] != -1:
			ray_minus = sqrt( pow((rays[n].get_collision_point().x - position.x), 2)  +  pow((rays[n].get_collision_point().y - position.y), 2) ) #same as 'var distance'
			A = a
			break
	
	for b in angles/2:
		if tile_cell[n+b] != -1:
			ray_plus = sqrt( pow((rays[n].get_collision_point().x - position.x), 2)  +  pow((rays[n].get_collision_point().y - position.y), 2) ) #same as 'var distance'
			B = b
			break
	
	#if ray_minus != null && ray_plus != null && A != null && B != null:
	if abs(ray_minus) > abs(ray_plus):
		tile_cell[n] = tile_cell[n-A]
	
	else:
		tile_cell[n] = tile_cell[n+B]
	
	return
