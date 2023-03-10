extends KinematicBody2D

var flip_frontback = true
export var positionZ = 0
export var true_anim = 0
var anim = 0
export var scale_extra = Vector2(float(0.8),float(0.8))
var texture = preload("res://assets/sprites ped0a.png")
export var vframes = 5
export var hframes = 10
export var rotations = 8
var darkness = 1
var dynamic_darkness = true
var dontScale = 0
var dontZ = false
var dontMove = false
var dontCollideSprite = false
var dontCollideWall = false







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
var reflect = 0
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
					#positionZ = heightsBT.y
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
					if reflect != 3:
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
			
			if body.is_in_group("car"):
				position += Vector2(sign(body.motion.x),sign(body.motion.y))*5
				motion = body.motion
				
				#rotation_degrees = (position - body.position).angle() + PI
				
				if true_anim != 23:
					if body.motion.length() > ouch_resist:
						interest = body.motion.length()/3
						ouch_car(body.motion.length())
					else:
						ouch_car(0)
			
			elif body.is_in_group("ped") && (body != self) && !startle && !gun_on && (health > 0):
				if body.health < 0:
					$Audio.npc_scream()
					startle = true
				else:
					var which = randi() % 5 #chances of staying quiet
					if which == 0:
						$Audio.npc_bump()
					elif which == 1:
						$Audio.npc_talk()


var ouch_resist = 50
var fall_resist = 850

func wait():
	motion = lerp(motion, Vector2(0,0), 0.1)
	interest -= 1
	
	
	if true_anim == 23:
		if health < 0:
			die()
	
	if interest < 0:
		if true_anim == 23:
			change_state(STATES.GETUP)
		else:
			if attacker != null:
				if aggressive:
					$Audio.npc_treat()
				else:
					$Audio.npc_scream()
			
			change_state(STATES.WALK)


func ouch_car(dmg):
	change_state(STATES.WAIT)
	health -= dmg/2
	
	if dmg == 0:
		interest = 10 + randi() % 20
		change_state(STATES.LOOK)
	elif (dmg > fall_resist) or (health <= 0):
		startle = true
		interest = dmg/10
		falldown()
	else:
		startle = true
		interest = dmg/2
		$AnimationPlayer.stop()
		$AnimationPlayer.play("ouch")

func getup():
	motion = lerp(motion, Vector2(), 1)
	
	if motion.length() < 10:
		if health <= 0:
			die()
		else:
			$AnimationPlayer.play("getup")
			dontCollideSprite = false
	else:
		die()

export var health = 1000
var bloodtimer = 0

func die():
	if reflect != 3:
		dontCollideSprite = true
		$AnimationPlayer.stop()
		$Audio.npc_die()
		head_height = 0
		spr_height /= 2
		shadow_height /= 2
		reflect = 3
	bloodtimer = lerp(bloodtimer, 1, 0.01)
	
	var rot_object = rad_overflow((position-Worldconfig.player.position).angle()-PI/2)
	if ((position - Worldconfig.player.position).length() > Worldconfig.player.draw_distance/Worldconfig.player.lod_ddist_divi) && ((Worldconfig.player.rotation_angle > PI/2 && Worldconfig.player.rotation_angle < 3*PI/2 && (rot_object < Worldconfig.player.rot_minus90 or rot_object > Worldconfig.player.rot_plus90))   or   (rot_object < Worldconfig.player.rot_minus90 && rot_object > Worldconfig.player.rot_plus90)):
		queue_freedom()

func queue_freedom():
	Worldconfig.npcs -= 1
	position = Vector2(INF,INF)
	queue_free()



export var startle = false
var attacker = null

func damage(damage,owner):
	change_state(STATES.WAIT)
	startle = true
	$AnimationPlayer.play("damage")
	health -= damage
	interest = 10 + randi() %10
	
	if health <= 0:
		falldown()
	
	if (owner != null):# && ($AnimationPlayer.current_animation_position > 0.5):
		attacker = owner


var feet_terrain = 0


func falldown():
	$AnimationPlayer.play("fall")
	dontCollideSprite = true



func _on_ColArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
#	if body.is_in_group("floor"):
		#on_floor = false#think weg think
		if col_floors.has(body):
			col_floors.erase(body)
			compareZ = INF
			
			if (col_floors.size() == 0) && (!dontCollideWall):
				if (positionZ <= Worldconfig.player.min_Z): positionZ = Worldconfig.player.min_Z
				shadowZ = Worldconfig.player.min_Z
			
	
#	if body.is_in_group("wall"):
		elif col_walls.has(body):
			col_walls.erase(body)
	
	#if body.is_in_group("sprite"):
		elif col_sprites.has(body):
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

var starting_heights = []

func divide_heights():
	spr_height = starting_heights[0]/2
	shadow_height = starting_heights[1]/2
	reflect_height = starting_heights[2]/2

func height_restore():
	spr_height = starting_heights[0]
	shadow_height = starting_heights[1]
	reflect_height = starting_heights[2]

func _ready():
	#add_collision_exception_with(Worldconfig.player)
	if Worldconfig.playercar != null:
		add_collision_exception_with(Worldconfig.playercar)
	
	true_anim = 0
	interest_luck += randi() % 500
	aggressive = randi() % 3
	skin = randi() % 5
	$Audio.pitch_scale += float(randi() % 25)/100
	$Audio.pitch_scale -= float(randi() % 25)/100
	
	if skin == 0:#ME
		$Audio.minus = -24
	elif skin == 1:#MOM
		$Audio.minus = -5
	else:
		$Audio.minus = -10
	
	if $CollisionShape2D.position != Vector2(0,0):
		position = to_global($CollisionShape2D.position)
		$CollisionShape2D.position = Vector2(0,0)
		
	 ##############################################################
	scale_extra += Vector2(float(randi()%100)/100, float(randi()%50)/100)
	spr_height = spr_height*scale_extra.y
	shadow_height = shadow_height*scale_extra.y
	reflect_height = reflect_height*scale_extra.y
	
	starting_heights = [spr_height, shadow_height, reflect_height]
	
	
	
	
	speed += randi() % 300
	health += randi() % 1000
	health -= randi() % 999
	
	modulate = Color8(randi() % 510, randi() % 510,randi() % 510)
	
	for n in get_tree().get_nodes_in_group("path"):
		if abs((n.position - position).length()) < closest: 
			closest = abs((n.position - position).length())
			target = n
	
	
	#for n in get_tree().get_nodes_in_group("ped"):
	#	add_collision_exception_with(n)
	
	startle = false



enum STATES {WALK,LOOK,WAIT,GETUP,ATTACK}
export(int) var state = STATES.WALK

func change_state(new_state):
	state = new_state


var npcA = [preload("res://assets/sprites ped0a.png"), preload("res://assets/sprites ped1a.png"), preload("res://assets/sprites ped2a.png"), preload("res://assets/sprites ped3a.png"), preload("res://assets/sprites ped4a.png")]
var npcB = [preload("res://assets/sprites ped0b.png"), preload("res://assets/sprites ped1b.png"), preload("res://assets/sprites ped2b.png"), preload("res://assets/sprites ped3b.png"), preload("res://assets/sprites ped4b.png")]
var npcC = [preload("res://assets/sprites ped0c.png"), preload("res://assets/sprites ped1c.png"), preload("res://assets/sprites ped2c.png"), preload("res://assets/sprites ped3c.png"), preload("res://assets/sprites ped4c.png")]
var skin = 0

func _process(_delta):
	if !weakref(target).get_ref(): target = null
	if !(weakref(attacker).get_ref()): attacker = null
	#if !target.is_instance_valid(): target = null
	#if !attacker.is_instance_valid(): attacker = null
	
	
	if true_anim > 19:
		texture = npcC[skin]
		hframes = 4
		rotations = 1
		anim = true_anim-20
		
		
	elif true_anim > 9:
		texture = npcB[skin]
		hframes = 10
		rotations = 4
		scale_extra.x = abs(scale_extra.x)
		anim = true_anim-10
		
		
	else:
		texture = npcA[skin]
		hframes = 10
		rotations = 4
		scale_extra.x = abs(scale_extra.x)
		anim = true_anim
		
		
	
	
	match state:
		STATES.WALK:
			walk()
		STATES.LOOK:
			look()
		STATES.WAIT:
			wait()
		STATES.GETUP:
			getup()
		STATES.ATTACK:
			attack()
	
	if (position - Worldconfig.player.position).length() > Worldconfig.player.draw_distance:
		queue_freedom()
	
	#print($AnimationPlayer.current_animation,"   ",state)
	
	

func attack():
	if attacker != null:
		if attacker.health <= 0:
			attacker = null
			gun_on = false
		
		motion = lerp(motion, Vector2(), 0.5)
		change_state(STATES.ATTACK)
		var random = randi() % 30
		if aggressive == 2 && !gun_on:
			$AnimationPlayer.play("shootget")
		elif aggressive == 1:
			if random < 4:
				$Audio.npc_trashtalk()
			$AnimationPlayer.play("punch")
		elif aggressive == 2:
			if random < 4:
				$Audio.npc_trashtalk()
			$AnimationPlayer.play("shoot")
	
	else:
		change_state(STATES.LOOK)

var aggressive = 2
var gun_on = false


const shot = preload("res://objects/bullet.tscn")
func shoot():
	if aggressive == 1:
		pass
	elif aggressive == 2:
		var shoot_instance = shot.instance()
		shoot_instance.positionZ = positionZ + head_height
		shoot_instance.position = position + Vector2(50,0).rotated(deg2rad(rotation_degrees) + PI/2)
		shoot_instance.motion = Vector2(0,10000).rotated(deg2rad(rotation_degrees))
		shoot_instance.daddy = self
		add_collision_exception_with(shoot_instance)
		get_parent().add_child(shoot_instance)











var interest_luck = 100

func player_hi():
	if (attacker == null) && !startle && (health > 0):
		motion = Vector2()
		
		if aggressive == 0:
			if Worldconfig.player.guninv <= 0:
				target = Worldconfig.player
				interest = interest_luck*3
				$Audio.npc_talk()
				
				if (interest_luck/2) > 50:
					interest_luck /= 2
					
			
			elif Worldconfig.player.guninv == 1:
				target = Worldconfig.player
				interest = interest_luck*5
				$Audio.npc_beg()
			
			elif Worldconfig.player.guninv >= 2:
				startle = true
				$Audio.npc_scream()
				
			
		
		elif aggressive == 1:
			if Worldconfig.player.guninv <= 0:
				$Audio.npc_bump()
			
			elif Worldconfig.player.guninv == 1:
				$Audio.npc_treat()
				target = Worldconfig.player
				interest = interest_luck*10
			
			elif Worldconfig.player.guninv >= 2:
				$Audio.npc_beg()
				aggressive = 0
				startle = true
		
		elif aggressive == 2:
			if Worldconfig.player.guninv <= 0:
				$Audio.npc_treat()
			elif Worldconfig.player.guninv >= 1:
				$Audio.npc_trashtalk()
				attacker = Worldconfig.player
	
	elif gun_on:
		change_state(STATES.ATTACK)

func walk():
	if health > 0:
		if (attacker == null) or (aggressive == 0):
			if abs(distanceXY.length()) < 50:
				old_targets.push_back(target)
				closest = INF
				interest = randi() % interest_luck
				if (interest <= 50) && !startle:
					change_state(STATES.LOOK)
				
				
				for n in get_tree().get_nodes_in_group("path"):
					if !old_targets.has(n):
						if abs((n.position - position).length()) < closest: 
							closest = abs((n.position - position).length())
							new_target = n
				target = new_target
				if old_targets.size() > 10:
					old_targets.remove(0)
		
		
		
		
		else:
				#print(((target.position - position).angle()-PI/2 - deg2rad(rotation_degrees)),"=    ",overflow(rad2deg((target.position - position).angle()-PI/2),0,360),"   -   ",(rotation_degrees))
			#print(
			#rad2deg((target.position - position).angle()-PI/2) - (rotation_degrees),"\n",
			#"   =   ",
			#overflow(rad2deg((target.position - position).angle()-PI/2),0,360),
			#"   -   ",
			#overflow((rotation_degrees),0,360)
			#" ")
			
			#print(rad2deg((target.position - position).angle()-PI/2) - int((rotation_degrees)))
			#print(int((rotation_degrees)) - rad2deg((target.position - position).angle()-PI/2))
			
			#rotation_degrees = lerp_angle(rotation_degrees, (target.position - position).angle() - rad2deg(PI/2), 0.1)
			#if (((overflow(rad2deg((target.position - position).angle()-PI/2),0,360))) - deg2rad(rotation_degrees)) < 0.5:
			#if overflow(rad2deg((target.position - position).angle()-PI/2),0,360) - overflow((rotation_degrees),0,360) < 0.5:
			#if abs(int(rad2deg((target.position - position).angle()-PI/2)) - int((rotation_degrees))) < 1:
			#if rad2deg((target.position - position).angle()-PI/2) - int((rotation_degrees)) > -270:
				rotation_degrees = rad2deg((position - target.position).angle() + PI/2)
				
				if aggressive == 1:
					if (attacker.position - position).length() < 150:
						#target = null
						change_state(STATES.ATTACK)
					else:
						target = attacker
					
				elif aggressive == 2:
					#ideally, if target is in sight :/
					if (attacker.position - position).length() < 1000:
						#target = null
						change_state(STATES.ATTACK)
						
					else:
						target = attacker
		
		
		
		
		if target != null:
			if !startle or (attacker == null):
				motion = lerp(motion,  Vector2(speed, 0).rotated((position - target.position).angle() + PI),  turn)
				rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - target.position).angle() + PI/2, 0.05))
				#rotation_degrees = lerp_angle(rotation_degrees, (target.position - position).angle() + rad2deg(PI/2), 0.05)
			
			else:
				motion = lerp(motion,  Vector2(speed*2, 0).rotated((position - target.position).angle() + PI),  turn)
				rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - target.position).angle() + PI/2, 0.05))
				#rotation_degrees = lerp_angle(rotation_degrees, (target.position - position).angle() + rad2deg(PI/2), 0.1)
			
			distanceXY = position - target.position
		
		
		
		
		#if $AnimationPlayer != null:
		if motion.length() > 100:
			if !gun_on:
				if startle or (attacker != null): $AnimationPlayer.play("run")
				else: $AnimationPlayer.play("walk")
			else:
				$AnimationPlayer.play("shootwalk")
			
			
		else:
			idleanim()
		

var interest = 0

func look():
	motion = lerp(motion, Vector2(0,0), 0.5)
	idleanim()
	
	if target != null:
		rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - target.position).angle() + PI/2, 0.025))
	interest -= 1
	
	if (interest < 0) or startle:
		change_state(STATES.WALK)

func idleanim():
		$AnimationPlayer.stop()
		if gun_on:
			true_anim = 15
		elif (aggressive == 1) && ((attacker != null) or (target == Worldconfig.player)):
			true_anim = 11
		elif startle or ((Worldconfig.player.guninv >= 1) && (target == Worldconfig.player)):
			true_anim = 10
		elif (aggressive == 2) && (attacker == null):
			true_anim = 14
		else:
			true_anim = 0

func ouch_voice_random():
	var which
	if aggressive == 0:
		which = randi() % 6 #chances of staying quiet
		if which == 0:
			$Audio.npc_beg()
		elif which == 1:
			$Audio.npc_pain()
		elif which == 2:
			$Audio.npc_bump()
		elif which == 3:
			$Audio.npc_breathe()
		elif which == 4:
			$Audio.npc_die()
	
	else:
		which = randi() % 3
		if which == 0:
			$Audio.npc_treat()
		elif which == 1:
			$Audio.npc_trashtalk()
		elif which == 2:
			$Audio.npc_bump()

func ouch_voice2():
	var which = randi() % 2
	
	if which == 0:
		$Audio.npc_pain()
	elif which == 1:
		$Audio.npc_scream()





func rad_overflow(N):
	if N > PI*2:
		N -= PI*2
	elif N < 0:
		N += PI*2
	
	return N


func overflow(N, minn, maxx):
	while N > maxx:
		N -= range(minn, maxx).size()
	
	while N < minn:
		N += range(minn, maxx).size()
	
	return N

