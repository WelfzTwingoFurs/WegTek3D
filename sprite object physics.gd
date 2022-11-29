extends KinematicBody2D

export var positionZ = 0
export var anim = 0
export var scale_extra = Vector2(float(0.5),float(1))
export var texture = "res://assets/sprites EGA jake.png"
export var vframes = 5
export var hframes = 10
export var rotations = 8
export(float) var darkness = 1
export(bool) var dynamic_darkness = false


func _ready():
	if $CollisionShape2D.position != Vector2(0,0):
		position = to_global($CollisionShape2D.position)
		$CollisionShape2D.position = Vector2(0,0)










var motion = Vector2()

func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	
	#if on_floor == true:
	#	if Input.is_action_pressed("ply_jump"):
	#		jump()
	
	if on_floor == false:
		if (col_floors.size() == 0 && positionZ <= Worldconfig.player.min_Z):
			on_floor = true
			motionZ = 0
		else:
			motionZ -= GRAVITY
		
	else:
		motionZ = 0
	
	positionZ += motionZ
	
	if motionZ < 0:
		move_dir.z = -1
	elif motionZ > 0:
		move_dir.z = 1
	elif motionZ == 0:
		move_dir.z = 0
	
	collide()

export(float) var GRAVITY = 0.5
export(float) var JUMP = 10
export var obj_height = 45
var col_walls = []
var col_floors = []
var move_dir = Vector3(0,0,0)
var on_floor = false
var motionZ = 0
export(bool) var shadow = true
var shadowZ = INF
export var shadow_height = 0

func collide():
	for n in col_walls.size():
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
			if (positionZ <= heightsBT.x && positionZ+obj_height >= heightsBT.x) or (positionZ >= heightsBT.x && positionZ+obj_height <= heightsBT.y) or (positionZ < heightsBT.y && positionZ+obj_height >= heightsBT.y): 
				# pé < topo, cabeça > topo, pé - topo = <obj_height
				if col_walls[n].jumpover && (positionZ < heightsBT.y && positionZ+obj_height > heightsBT.y) && (positionZ - heightsBT.y < obj_height/2):
					positionZ = heightsBT.y
				
				elif col_walls[n].jumpover && (positionZ < heightsBT.x && positionZ+obj_height > heightsBT.x) && ((positionZ+obj_height) - heightsBT.x < obj_height/2):
					positionZ = heightsBT.x - obj_height -1
				
				else:
					remove_collision_exception_with(col_walls[n])
			
			else:
				add_collision_exception_with(col_walls[n])
	
	
	
	var compareZ = INF
	
	if col_floors.size() == 0:
		shadowZ = Worldconfig.player.min_Z
	
	for n in col_floors.size():
		if dynamic_darkness:
			darkness = col_floors[n].darkness
			
	#if col_floors != null:
		if col_floors[n].flag_1height:
			
			#if col_floors[n].heights[0] < positionZ: #shadow position#
			if col_floors[n].heights[0] - positionZ < compareZ:
				compareZ = col_floors[n].heights[0] - positionZ
				shadowZ = col_floors[n].heights[0]
			
			
			
			if col_floors[n].absolute == -1:
				if positionZ > col_floors[n].heights[0]-1:
					positionZ = col_floors[n].heights[0] - obj_height
					on_floor = false
			elif col_floors[n].absolute == 1:
				if positionZ < col_floors[n].heights[0]-obj_height:
					positionZ = col_floors[n].heights[0]
					on_floor = true
			
			
			if move_dir.z == -1:
				if (positionZ < col_floors[n].heights[0]) && (positionZ+obj_height > col_floors[n].heights[0]):
					positionZ = col_floors[n].heights[0]# + obj_height
					
					on_floor = true 
					if motionZ < 0:
						motionZ = 0
						positionZ = col_floors[n].heights[0]
			
			if move_dir.z == 1:
				if (positionZ < col_floors[n].heights[0]) && (positionZ+obj_height > col_floors[n].heights[0]):
					positionZ = col_floors[n].heights[0] - obj_height
					
					on_floor = false
					if motionZ > 0:
						motionZ = 0
		


func jump():
	if on_floor == true:
		motionZ += JUMP
		on_floor = false









func _on_ColArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		if !col_floors.has(body):
			if (col_floors.size() == 0) && (body.flag_1height) && (on_floor == true) && (body.heights[0] < positionZ): on_floor = false
			
			col_floors.push_back(body)
			
			
	elif body.is_in_group("wall"):
		if !col_walls.has(body):
			col_walls.push_back(body)

func _on_ColArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		on_floor = false
		if col_floors.has(body):
			col_floors.erase(body)
			
			if (col_floors.size() == 0) && (positionZ <= Worldconfig.player.min_Z):
				positionZ = Worldconfig.player.min_Z
			
	
	if body.is_in_group("wall"):
		if col_walls.has(body):
			col_walls.erase(body)
