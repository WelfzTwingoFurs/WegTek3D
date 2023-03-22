extends KinematicBody2D

var scale_extra = Vector2(0.5,0.5)
var dontScale = 0
var spr_height = 0
var texture = preload("res://textures/wheelEGA64.png")
var vframes = 1
var hframes = 1
var dontZ = false
var rotations = 1
var anim = 0
var shadow = false
var darkness = 1

export var positionZ = 0
export(bool) var dontMove = false
export(bool) var dontCollideSprite = false
export(bool) var dontCollideWall = false
export(bool) var stepover = false

func _ready():
	if !is_in_group("sprite"):
		add_collision_exception_with(Worldconfig.player)
	
	remove_from_group("rendersprite")








var motion = Vector2()

func _physics_process(_delta):
	motion = Vector2(0,0)
	
	if !dontCollideSprite:
		if on_body == true:
			motionZ = 0
			positionZ = body_on.positionZ + body_on.head_height
			if col_sprites.size() == 0:
				on_body = false
	
	if !dontCollideWall:
		if on_floor == false:
			if (col_floors.size() == 0 && positionZ <= Worldconfig.player.min_Z):
				on_floor = true
				motionZ = 0
			elif col_floors.size() != 0:#think about this
				motionZ -= GRAVITY
			else:#think about this
				on_floor = true
			
		else:
			motionZ = 0
	
	positionZ += motionZ
	
	if motionZ < 0:
		move_dir.z = -1
	elif motionZ > 0:
		move_dir.z = 1
	elif motionZ == 0:
		move_dir.z = 0
	
	move_dir.x = sign(motion.x)
	move_dir.y = sign(motion.y)
	
	collide()

export(float) var GRAVITY = 0.5
export var head_height = 65
var col_walls = []
var col_floors = []
var col_sprites = []
var move_dir = Vector3(0,0,0)
var on_floor = false
var on_body = false
var body_on = null
var motionZ = 0

func collide():
	for n in col_sprites.size():
		if (dontCollideSprite) or (col_sprites[n].dontCollideSprite):
			add_collision_exception_with(col_sprites[n])
			
		
		else:
			var heightsBT = Vector2(-1,1)
			
			heightsBT.x = col_sprites[n].positionZ
			heightsBT.y = col_sprites[n].positionZ+col_sprites[n].head_height
			
			
			
			#pé < baixo, cabeça > baixo
			#pé > baixo, cabeça < topo
			#pé < topo, cabeça > topo
			if (positionZ <= heightsBT.x && positionZ+head_height >= heightsBT.x) or (positionZ >= heightsBT.x && positionZ+head_height <= heightsBT.y) or (positionZ < heightsBT.y && positionZ+head_height >= heightsBT.y): 
				# pé < topo, cabeça > topo, pé - topo = <head_height
				if (positionZ < heightsBT.y && positionZ+head_height > heightsBT.y) && (positionZ - heightsBT.y < head_height/2):
					positionZ = heightsBT.y
					#on_floor = true
					on_body = true
					body_on = col_sprites[n]
				
				elif (positionZ < heightsBT.x && positionZ+head_height > heightsBT.x) && ((positionZ+head_height) - heightsBT.x < head_height/2):
					positionZ = heightsBT.x - head_height -1
					on_body = false
				
				else:
					remove_collision_exception_with(col_sprites[n])
			
			else:
				add_collision_exception_with(col_sprites[n])
	
	
	
	
	
	
	for n in col_walls.size():
		if dontCollideWall:
			add_collision_exception_with(col_walls[n])
			
		
		else:
			if col_walls[n].flag_2height:
				var heightsBT = Vector2(-1,1)
				
				if col_walls[n].heights[1] < col_walls[n].heights[2]:
					heightsBT.x = col_walls[n].heights[1]
					heightsBT.y = col_walls[n].heights[2]
				else:
					heightsBT.x = col_walls[n].heights[2]
					heightsBT.y = col_walls[n].heights[1]
				
				#pé < baixo, cabeça > baixo
				#pé > baixo, cabeça < topo
				#pé < topo, cabeça > topo
				if (positionZ <= heightsBT.x && positionZ+head_height >= heightsBT.x) or (positionZ >= heightsBT.x && positionZ+head_height <= heightsBT.y) or (positionZ < heightsBT.y && positionZ+head_height >= heightsBT.y): 
					# pé < topo, cabeça > topo, pé - topo = <head_height
					if col_walls[n].jumpover && (positionZ < heightsBT.y && positionZ+head_height > heightsBT.y) && (positionZ - heightsBT.y < head_height/2):
						positionZ = heightsBT.y
					
					elif col_walls[n].jumpover && (positionZ < heightsBT.x && positionZ+head_height > heightsBT.x) && ((positionZ+head_height) - heightsBT.x < head_height/2):
						positionZ = heightsBT.x - head_height -1
					
					else:
						remove_collision_exception_with(col_walls[n])
				
				else:
					add_collision_exception_with(col_walls[n])
	
	
	
	
	
	
	for n in col_floors.size():
		darkness = col_floors[n].darkness
		
		if dontCollideWall:
			add_collision_exception_with(col_floors[n])
		
		else:
		#if col_floors != null:
			if col_floors[n].flag_1height:
				if col_floors[n].absolute == -1:
					if positionZ > col_floors[n].heights[0]-1:
						positionZ = col_floors[n].heights[0] - head_height
						on_floor = false
				elif col_floors[n].absolute == 1:
					if positionZ < col_floors[n].heights[0]-head_height:
						positionZ = col_floors[n].heights[0]
						if (motionZ < -10) && !on_floor: get_owner().wheelsound.car_land(motionZ)
						on_floor = true
				
				#if on_floor == false:
				if move_dir.z == -1:
					if (positionZ < col_floors[n].heights[0]) && (positionZ+head_height > col_floors[n].heights[0]):
						positionZ = col_floors[n].heights[0]# + head_height
						
						if (motionZ < -10) && !on_floor: get_owner().wheelsound.car_land(motionZ)
						on_floor = true 
						if motionZ < 0:
							motionZ = 0
							positionZ = col_floors[n].heights[0]
				
				if move_dir.z == 1:
					if (positionZ < col_floors[n].heights[0]) && (positionZ+head_height > col_floors[n].heights[0]):
						positionZ = col_floors[n].heights[0] - head_height
						
						on_floor = false
						if motionZ > 0:
							motionZ = 0
			
			
			
			
			
			else: #slope moment
				var new_height = Vector2(slope(
					Vector3(to_global(position).x, to_global(position).y,0), 
					Vector3(col_floors[n].points[0].x, col_floors[n].points[0].y, col_floors[n].heights[0]), 
					Vector3(col_floors[n].points[1].x, col_floors[n].points[1].y, col_floors[n].heights[1]), 
					Vector3(col_floors[n].points[2].x, col_floors[n].points[2].y, col_floors[n].heights[2]), n)) #+ margin
				
				#positionZ = new_height
				
				if (col_floors[n].absolute == 1) && (positionZ < new_height.x):
					positionZ = new_height.x
					if (motionZ < -10) && !on_floor: get_owner().wheelsound.car_land(motionZ)
					on_floor = true
				elif (col_floors[n].absolute == -1) && (positionZ + head_height > new_height.x):
					positionZ = new_height.x - head_height
					on_floor = false
					continue
				
				
				if new_height.x > positionZ + head_height:
					if new_height.x < positionZ + head_height + motionZ:
						motionZ = -motionZ
				
				elif new_height.y > [col_floors[n].heights[0], col_floors[n].heights[1], col_floors[n].heights[2]].max(): #THINK ABOUT THIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIISSSISISIISISISISIISIS
					positionZ = new_height.y
					on_floor = false
				#	motionZ += (new_height.y - positionZ)*10 #THINK ABOUT THIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIISSSSSSSSSSSSSSSSSSSS
				
				elif new_height.x > positionZ:
					positionZ = new_height.x
					if (motionZ < -10) && !on_floor: get_owner().wheelsound.car_land(motionZ)
					on_floor = true
				else:
					if on_floor:
						positionZ = new_height.x
					else:
						on_floor = false
				
				#positionZ = new_height
				#print(positionZ)


var heading = Vector2(0,0)

func slope(v0,v1,v2,v3, n):
	var normal = (v2 - v1).cross(v3 - v1).normalized()
	var dir = Vector3(0.0, 0.0, 1.0)
	var r = v0 + dir * ((v1.dot(normal)) - v0.dot(normal)) / dir.dot(normal)
	
	#if r.z > [col_floors[n].heights[0], col_floors[n].heights[1], col_floors[n].heights[2]].max():
	#	motionZ = abs(r.z)
	
	v0 += Vector3(heading.x, heading.y, 0)
	var r2 = v0 + dir * ((v1.dot(normal)) - v0.dot(normal)) / dir.dot(normal)
	if r2.z > [col_floors[n].heights[0], col_floors[n].heights[1], col_floors[n].heights[2]].max():
		return Vector2(r.z, r2.z)
	
	return Vector2(r.z, r2.z)
	









func _on_ColArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		if !col_floors.has(body):
			if (col_floors.size() == 0) && (body.flag_1height) && (on_floor == true) && (body.heights[0] < positionZ): on_floor = false
			
			col_floors.push_back(body)
			
	elif body.is_in_group("wall"):
		if !col_walls.has(body):
			col_walls.push_back(body)
	
	elif body.is_in_group("sprite"):
		if !col_sprites.has(body):
			col_sprites.push_back(body)

func _on_ColArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	#if body.is_in_group("floor"):
		
		if col_floors.has(body):
			on_floor = false
			col_floors.erase(body)
			
			if (col_floors.size() == 0) && (!dontCollideWall):
				if (positionZ <= Worldconfig.player.min_Z): positionZ = Worldconfig.player.min_Z
			
	
	#if body.is_in_group("wall"):
		if col_walls.has(body):
			col_walls.erase(body)
	
	#if body.is_in_group("sprite"):
		if col_sprites.has(body):
			col_sprites.erase(body)
			on_body = false
			on_floor = false
