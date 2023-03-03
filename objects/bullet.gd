extends KinematicBody2D

var positionZ = 0
var anim = 0
var scale_extra = Vector2(1,1)
var texture = preload("res://textures/solid1.png")
var vframes = 1
var hframes = 1
var rotations = 8
var darkness = 1
var dynamic_darkness = false
var dontScale = -1
var dontZ = false
var dontMove = false
var dontCollideSprite = false
var dontCollideWall = false
var motion = Vector2()
export var speed = 1

var starting_speed
var daddy = null

func _ready():
	starting_speed = Vector3(motion.x, motion.y, motionZ)

func _physics_process(_delta):
	if Vector3(motion.x, motion.y, motionZ) != starting_speed:
		die()
	
	motion = move_and_slide(motion, Vector2(0,-1))
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

export(float) var GRAVITY = 0
var spr_height = 0
var head_height = 0
var col_walls = []
var col_floors = []
var col_sprites = []
var move_dir = Vector3(0,0,0)
var on_floor = false
var on_body = false
var body_on = null
var motionZ = 0
var shadow = false
var shadowZ = INF
var reflect = 0
var shadow_height = 0
var reflect_height = 0
var compareZ = INF
var stepover = false


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
				#remove_collision_exception_with(col_sprites[n])
				die()
			
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
					die()
				
				else:
					add_collision_exception_with(col_walls[n])
	
	
	
	
	
	if col_floors.size() == 0:
		shadowZ = 0
	
	for n in col_floors.size():
		if dynamic_darkness:
			darkness = col_floors[n].darkness
		
		if col_floors[n].flag_1height:
			if col_floors[n].absolute == -1:
				if positionZ > col_floors[n].heights[0]-1:
					die() 
			elif col_floors[n].absolute == 1:
				if positionZ < col_floors[n].heights[0]-head_height:
					die()
			
			#if on_floor == false:
			if move_dir.z == -1:
				if (positionZ < col_floors[n].heights[0]) && (positionZ+head_height > col_floors[n].heights[0]):
					die() 
			
			if move_dir.z == 1:
				if (positionZ < col_floors[n].heights[0]) && (positionZ+head_height > col_floors[n].heights[0]):
					die() 
		
		
		
		
		
		else:
			var new_height = slope(
				Vector3(position.x,position.y,0), 
				Vector3(col_floors[n].points[0].x, col_floors[n].points[0].y, col_floors[n].heights[0]), 
				Vector3(col_floors[n].points[1].x, col_floors[n].points[1].y, col_floors[n].heights[1]), 
				Vector3(col_floors[n].points[2].x, col_floors[n].points[2].y, col_floors[n].heights[2])) #+ margin
			
			shadowZ = new_height
			
			if (col_floors[n].absolute == 1) && (positionZ < new_height):
				die()
			elif (col_floors[n].absolute == -1) && (positionZ + head_height > new_height):
				die() 




func slope(v0,v1,v2,v3):
	var normal = (v2 - v1).cross(v3 - v1).normalized()
	var dir = Vector3(0.0, 0.0, 1.0)
	var r = v0 + dir * ((v1.dot(normal)) - v0.dot(normal)) / dir.dot(normal)
	
	return r.z
	













export var damage = 500

func _on_ColArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		if !col_floors.has(body):
			if (col_floors.size() == 0) && (body.flag_1height) && (on_floor == true) && (body.heights[0] < positionZ): on_floor = false
			
			col_floors.push_back(body)
			
	elif body.is_in_group("wall"):
		if !col_walls.has(body):
			col_walls.push_back(body)
	
	elif body.is_in_group("sprite"):
		if body != self:
			if !col_sprites.has(body):
				col_sprites.push_back(body)
				
				if body.is_in_group("ouchy") && body.health > 0:
					body.damage(damage, daddy)
				
				die()



func _on_ColArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		if col_floors.has(body):
			col_floors.erase(body)
	
	if body.is_in_group("wall"):
		if col_walls.has(body):
			col_walls.erase(body)
	
	if body.is_in_group("sprite"):
		if col_sprites.has(body):
			col_sprites.erase(body)




func die():
	$Audio.gun_pistol_hit()
	position = Vector2(INF,INF)
	queue_free()
