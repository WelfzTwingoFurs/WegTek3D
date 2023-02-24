extends StaticBody2D
#Use this to make rooms. Heights double that of polygon size.
export (Array, float) var heights = [0,100]
#for 2: floor=[0], ceiling=[1]
#for =polygon.size()*2: floor=[n], ceiling=[n*2]
#for =polygon.size()+1:...
export var plus1_mode = 0
#floor = heights, ceiling = +1, aka while
# 1, extra
# 2, bot+extra
# 3, bot*extra
# 4, bot/extra

export var onesided = 0
export var textures_on = true
export var UV_textures = false
export (Array, String) var textures = ["res://icon.png","res://icon.png","res://icon.png"]
export (Array, Color) var colors = [Color(1,1,1,1),Color(1,1,1,1),Color(1,1,1,1)]
#"" if we don't wanna make this one!
#for 3: floor, ceiling, all walls
#for polygon.size()/2 + 2: floor, ceiling, wall01, wall12, wall20
export(float) var darknesses = 1

export var collide = false
export var absolute = false
export var jumpover = false
export var reflect = false

var new_wall
var new_floor

func _ready():
	for n in textures.size():
		if !ResourceLoader.exists(textures[n]) && textures[n] != "":
			if n > $CollisionPolygon2D.polygon.size()-1:
				textures[n] = "res://assets/gradientthin.png"
			else:
				textures[n] = "res://assets/gradientthin.png"
	
	if collide:
		#if heights.size() == 2:
		#	if heights[0] > heights [1]:
		#		print("Ceiling and floor are inverted, At: ",$CollisionPolygon2D.polygon)
		#		queue_free()
		#	else:
		new_wall = load("res://map-wall collide for sector.tscn")
		new_floor = load("res://map-floor collide for sector.tscn")
		#else:
		#	print("Can't collide if we're doing diagonals, At: ",$CollisionPolygon2D.polygon)
		#	queue_free()
	else:
		new_wall = load("res://map-wall for sector.tscn")
		new_floor = load("res://map-floor for sector.tscn")
	
	if $CollisionPolygon2D.position != Vector2(0,0) or $CollisionPolygon2D.scale != Vector2(1,1) or $CollisionPolygon2D.rotation_degrees != 0:
		print(">M I S T A K E: map-sector's ColPoly2D position !=(0,0), scale !=(1,1), or rotation != 0. Do these with the StaticBody instead. At: ",$CollisionPolygon2D.polygon)
		queue_free()
	
	var make_new_floor = new_floor.instance()
	var make_new_ceiling = new_floor.instance()
	
	make_new_floor.spawn_shape_position = $CollisionPolygon2D.polygon
	make_new_ceiling.spawn_shape_position = $CollisionPolygon2D.polygon
	
	
	for n in $CollisionPolygon2D.polygon.size():
		#if (textures.size() == 2 && textures[2] != "")  or  (textures.size() == ($CollisionPolygon2D.polygon.size()/2 + 2) && textures[n+2] != ""):
		if textures[n] != "":
			var make_new_wall = new_wall.instance()
			
			make_new_wall.texture_path = textures[n]
			if range(colors.size()).has(n):
				make_new_wall.modulate = colors[n]
			
			
			make_new_wall.spawn_shape_position = [$CollisionPolygon2D.polygon[n], $CollisionPolygon2D.polygon[array_looping(n+1, $CollisionPolygon2D.polygon.size())]]
			
			
			if heights.size() == 2:
				make_new_wall.heights = [heights[0],heights[1]]
				
			
			elif heights.size() == $CollisionPolygon2D.polygon.size()+1:
				if plus1_mode == 1:
					#BOT: current, next. TOP: extra, extra
					make_new_wall.heights = [heights[n],   heights[array_looping(n+1, $CollisionPolygon2D.polygon.size())],   heights[heights.size()-1],   heights[heights.size()-1]]
					
				elif plus1_mode == 2:
					#BOT: current, next. TOP: current+extra, previous+extra
					make_new_wall.heights = [heights[n],   heights[array_looping(n+1, $CollisionPolygon2D.polygon.size())],   heights[array_looping(n+1, $CollisionPolygon2D.polygon.size())]+heights[heights.size()-1],   heights[n]+heights[heights.size()-1]]
				elif plus1_mode == 3:
					make_new_wall.heights = [heights[n],   heights[array_looping(n+1, $CollisionPolygon2D.polygon.size())],   heights[array_looping(n+1, $CollisionPolygon2D.polygon.size())]*heights[heights.size()-1],   heights[n]*heights[heights.size()-1]]
				elif plus1_mode == 4:
					make_new_wall.heights = [heights[n],   heights[array_looping(n+1, $CollisionPolygon2D.polygon.size())],   heights[array_looping(n+1, $CollisionPolygon2D.polygon.size())]/heights[heights.size()-1],   heights[n]/heights[heights.size()-1]]
				
				
#				if n == $CollisionPolygon2D.polygon.size()-1:
#					make_new_floor.heights = array_except_last(heights)
#
#					if plus1_mode == 1:
#						make_new_ceiling.heights = [heights[heights.size()-1]]
#
#					elif plus1_mode == 2:
#						make_new_ceiling.heights = array_plus(array_except_last(heights), heights[heights.size()-1])
#					elif plus1_mode == 3:
#						make_new_ceiling.heights = array_multiply(array_except_last(heights), heights[heights.size()-1])
#					elif plus1_mode == 3:
#						make_new_ceiling.heights = array_divide(array_except_last(heights), heights[heights.size()-1])
				
				
				
			
			elif heights.size() == $CollisionPolygon2D.polygon.size()*2:
				make_new_wall.heights = [heights[n],heights[n*2]]
				#make_new_floor.heights.append(heights[n])
				#make_new_ceiling.heights.append(heights[n*2])
				
				
			else:
				queue_free()
				
			
			make_new_wall.textures_on = textures_on
			make_new_wall.UV_textures = UV_textures
			make_new_wall.darkness = darknesses
			make_new_wall.jumpover = jumpover
			make_new_wall.onesided = onesided
			#if higfx: make_new_wall.add_to_group("higfx")
			add_child(make_new_wall)
			
		
		
		if textures[textures.size()-2] != "":
			make_new_floor.texture_path = textures[textures.size()-2]
			if range(colors.size()).has(n):
				make_new_floor.modulate = colors[colors.size()-2]
			
			if heights.size() == $CollisionPolygon2D.polygon.size()+1:
				if n == $CollisionPolygon2D.polygon.size()-1:
					make_new_floor.heights = array_except_last(heights)
			
			elif heights.size() == $CollisionPolygon2D.polygon.size()*2:
				make_new_floor.heights.append(heights[n])
		
		
		if textures[textures.size()-1] != "":
			make_new_ceiling.texture_path = textures[textures.size()-1]
			if range(colors.size()).has(n):
				make_new_ceiling.modulate = colors[colors.size()-1]
			
			if heights.size() == $CollisionPolygon2D.polygon.size()+1:
				if n == $CollisionPolygon2D.polygon.size()-1:
					if plus1_mode == 1:
						make_new_ceiling.heights = [heights[heights.size()-1]]
					elif plus1_mode == 2:
						make_new_ceiling.heights = array_plus(array_except_last(heights), heights[heights.size()-1])
					elif plus1_mode == 3:
						make_new_ceiling.heights = array_multiply(array_except_last(heights), heights[heights.size()-1])
					elif plus1_mode == 3:
						make_new_ceiling.heights = array_divide(array_except_last(heights), heights[heights.size()-1])
					
			
			elif heights.size() == $CollisionPolygon2D.polygon.size()*2:
				make_new_ceiling.heights.append(heights[n*2])
	
	
	
	if textures[textures.size()-2] != "":
		if heights.size() == 2:
			make_new_floor.heights   = [heights[0]]
			if collide && absolute:
				make_new_floor.absolute = 1
		
		make_new_floor.textures_on = textures_on
		make_new_floor.UV_textures = UV_textures
		make_new_floor.darkness = darknesses
		make_new_floor.reflect = reflect
		make_new_floor.onesided = -onesided
		#if higfx: make_new_floor.add_to_group("higfx")
		add_child(make_new_floor)
	
	if textures[textures.size()-1] != "":
		if heights.size() == 2:
			make_new_ceiling.heights = [heights[1]]
			if collide && absolute:
				make_new_ceiling.absolute = -1
				if textures[textures.size()-2] == "":
					make_new_ceiling.absolute = 1
		
		make_new_ceiling.textures_on = textures_on
		make_new_ceiling.UV_textures = UV_textures
		make_new_ceiling.darkness = darknesses
		make_new_ceiling.reflect = reflect
		make_new_ceiling.onesided = onesided
		#if higfx: make_new_ceiling.add_to_group("higfx")
		add_child(make_new_ceiling)
	
	$CollisionPolygon2D.queue_free()




func array_looping(to_check, array_size):
	if to_check < 0:
		to_check += array_size
	
	if to_check > array_size-1:
		to_check -= array_size
	
	if (to_check < 0) or (to_check > array_size-1):
		to_check = array_looping(to_check, array_size)
	
	return(to_check)


func array_shifting(array, shifter):
	var new_array = []
	for n in array.size():
		new_array.append(array_looping(n+shifter,array.size()))
	return new_array
	


func array_plus(array, plus):
	for n in array.size():
		array[n] = array[n]+plus
	
	return array

func array_multiply(array, mult):
	for n in array.size():
		array[n] = array[n]*mult
	
	return array

func array_divide(array, div):
	for n in array.size():
		array[n] = array[n]/div
	
	return array


func array_except_last(array):
	var new_array = []
	for n in array.size()-1:
		new_array.append(array[n])
	
	return new_array




