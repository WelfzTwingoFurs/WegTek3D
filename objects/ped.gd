extends KinematicBody2D

export var positionZ = 0
export var anim = 0
export var scale_extra = Vector2(float(0.8),float(0.8))
export(Texture) var texture = preload("res://assets/sprites chaser jake.png")
export var vframes = 5
export var hframes = 10
export var rotations = 8
export(float) var darkness = 1
export(bool) var dynamic_darkness = false
export var dontScale = 0
export(bool) var dontZ = false
export(bool) var dontMove = false
export(bool) var dontCollideSprite = false
export(bool) var dontCollideWall = false







var motion = Vector2()

func _physics_process(_delta):
	if dontMove:
		motion = Vector2(0,0)
	else:
		motion = move_and_slide(motion, Vector2(0,-1))
	
	if !dontCollideSprite:
		if on_body == true:
			motionZ = 0
			positionZ = body_on.positionZ + body_on.head_height
			if col_sprites.size() == 0:
				on_body = false
	
	if !dontCollideWall:
		if on_floor == false:
			if (col_floors.size() == 0 && positionZ <= 0):
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
	
	move_dir.x = sign(motion.x)
	move_dir.y = sign(motion.y)
	
	collide()

export(float) var GRAVITY = 0.5
export(float) var JUMP = 10
export var spr_height = 0
export var head_height = 65
var col_walls = []
var col_floors = []
var col_sprites = []
var move_dir = Vector3(0,0,0)
var on_floor = false
var on_body = false
var body_on = null
var motionZ = 0
export(bool) var shadow = true
var shadowZ = INF
var reflect = false
export var shadow_height = 0
export var reflect_height = 0
var compareZ = INF
export var stepover = false


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
				if col_sprites[n].stepover && (positionZ < heightsBT.y && positionZ+head_height > heightsBT.y) && (positionZ - heightsBT.y < head_height*2):
					positionZ = heightsBT.y
					on_body = true
					body_on = col_sprites[n]
				
				elif col_sprites[n].stepover &&  (positionZ < heightsBT.x && positionZ+head_height > heightsBT.x) && ((positionZ+head_height) - heightsBT.x < head_height*2):
					positionZ = heightsBT.x - head_height -1
				
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
	
	
	
	
	
	if col_floors.size() == 0:
		shadowZ = 0
	
	for n in col_floors.size():
		if dynamic_darkness:
			darkness = col_floors[n].darkness
		
		if dontCollideWall:
			add_collision_exception_with(col_floors[n])
		
		else:
		#if col_floors != null:
			if col_floors[n].flag_1height:
				
				#if col_floors[n].heights[0] < positionZ: #shadow position#
				if col_floors[n].heights[0] - positionZ < compareZ:
					compareZ = col_floors[n].heights[0] - positionZ
					shadowZ = col_floors[n].heights[0]
					reflect = col_floors[n].reflect
				
				
				
				if col_floors[n].absolute == -1:
					if positionZ > col_floors[n].heights[0]-1:
						positionZ = col_floors[n].heights[0] - head_height
						on_floor = false
				elif col_floors[n].absolute == 1:
					if positionZ < col_floors[n].heights[0]-head_height:
						positionZ = col_floors[n].heights[0]
						on_floor = true
				
				#if on_floor == false:
				if move_dir.z == -1:
					if (positionZ < col_floors[n].heights[0]) && (positionZ+head_height > col_floors[n].heights[0]):
						positionZ = col_floors[n].heights[0]# + head_height
						
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
			
			
			
			
			
			else:
				var new_height = slope(
					Vector3(position.x,position.y,0), 
					Vector3(col_floors[n].points[0].x, col_floors[n].points[0].y, col_floors[n].heights[0]), 
					Vector3(col_floors[n].points[1].x, col_floors[n].points[1].y, col_floors[n].heights[1]), 
					Vector3(col_floors[n].points[2].x, col_floors[n].points[2].y, col_floors[n].heights[2])) #+ margin
				
				shadowZ = new_height
				
				if (col_floors[n].absolute == 1) && (positionZ < new_height):
					positionZ = new_height
					on_floor = true
				elif (col_floors[n].absolute == -1) && (positionZ + head_height > new_height):
					positionZ = new_height - head_height
					on_floor = false
					continue
				
				
				if move_dir:
					if new_height > positionZ + head_height:
						if new_height < positionZ + head_height + motionZ:
							#motionZ = -motionZ
							motionZ = 0
					
					elif new_height > positionZ:
						positionZ = new_height
						on_floor = true
					else:
						if on_floor:
							positionZ = new_height
						else:
							on_floor = false




func slope(v0,v1,v2,v3):
	var normal = (v2 - v1).cross(v3 - v1).normalized()
	var dir = Vector3(0.0, 0.0, 1.0)
	var r = v0 + dir * ((v1.dot(normal)) - v0.dot(normal)) / dir.dot(normal)
	
	return r.z
	















func _on_ColArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		if !col_floors.has(body):
			if (col_floors.size() == 0) && (body.flag_1height) && (on_floor == true) && (body.heights[0] < positionZ): on_floor = false
			
			col_floors.push_back(body)
			compareZ = INF
			
	elif body.is_in_group("wall"):
		if !col_walls.has(body):
			col_walls.push_back(body)
	
	elif body.is_in_group("sprite"):
		if !col_sprites.has(body):
			col_sprites.push_back(body)

func _on_ColArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("floor"):
		#on_floor = false#think weg think
		if col_floors.has(body):
			col_floors.erase(body)
			compareZ = INF
			
			if (col_floors.size() == 0) && (!dontCollideWall):
				if (positionZ <= Worldconfig.player.min_Z): positionZ = Worldconfig.player.min_Z
				shadowZ = Worldconfig.player.min_Z
			
	
	if body.is_in_group("wall"):
		if col_walls.has(body):
			col_walls.erase(body)
	
	if body.is_in_group("sprite"):
		if col_sprites.has(body):
			col_sprites.erase(body)
			on_body = false
			on_floor = false




##########################################################################################################################################################################



export var speed = 300
export var turn = 0.1
export(bool) var jumpy = false

var distanceXY = Vector2(0,0)

var target = self
var closest = INF
var old_targets = [null]
var new_target = null

func _ready():
	if anim > vframes*hframes:
		anim = 0
	
	if $CollisionShape2D.position != Vector2(0,0):
		position = to_global($CollisionShape2D.position)
		$CollisionShape2D.position = Vector2(0,0)
		
	 ##############################################################
	scale_extra += Vector2(float(randi()%100)/100, float(randi()%50)/100)
	spr_height += spr_height*scale_extra.y
	speed += (randi() % 300)
	
	modulate = Color8(randi() % 255, randi() % 255,randi() % 255)
	
	for n in get_tree().get_nodes_in_group("path"):
		if abs((n.position - position).length()) < closest: 
			closest = abs((n.position - position).length())
			target = n
	
	
	for n in get_tree().get_nodes_in_group("ped"):
		add_collision_exception_with(n)



enum STATES {WALK,LOOK,OUCH,FALL}
export(int) var state = STATES.WALK

func change_state(new_state):
	state = new_state

func _process(_delta):
	match state:
		STATES.WALK:
			walk()
		STATES.LOOK:
			look()
		STATES.OUCH:
			ouch()
		STATES.FALL:
			fall()
				
	

func walk():
	if abs(distanceXY.length()) < 15:
		old_targets.push_back(target)
		closest = INF
		interest = randi()% 1425 #
		if interest > 1500:
			change_state(STATES.LOOK)
		
		for n in get_tree().get_nodes_in_group("path"):
			if !old_targets.has(n):
				if abs((n.position - position).length()) < closest: 
					closest = abs((n.position - position).length())
					new_target = n
		target = new_target
		if old_targets.size() > 4:
			old_targets.remove(0)
	
	
	if target != null:
		motion = lerp(motion,  Vector2(speed, 0).rotated((position - target.position).angle() + PI),  turn)
		rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - target.position).angle() + PI/2, 0.05))
		
		distanceXY = position - target.position
	
	
	
	
	if $AnimationPlayer != null:
		if (abs(motion.x) > 2) or (abs(motion.y) > 2):
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.stop()
			anim = 0


var look_target
var interest

func look():
	motion = lerp(motion, Vector2(0,0), 0.5)
	$AnimationPlayer.stop()
	anim = 0
	
	if target != null:
		rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - target.position).angle() + PI/2, 0.025))
	interest -= 1
	
	if interest < 0:
		change_state(STATES.WALK)


func ouch():
	$AnimationPlayer.stop()
	anim = 5

func fall():
	$AnimationPlayer.play("fall")
