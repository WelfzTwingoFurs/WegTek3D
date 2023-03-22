extends KinematicBody2D

export var string = "Describe the vehicle"
export var color_top = Color(1,1,1)
export var color_sideL = Color(1,1,1)
export var color_sideR = Color(1,1,1)
export var color_front = Color(1,1,1)
export var color_back = Color(1,1,1)
export var color_hood = Color(1,1,1)
export var color_trunk = Color(1,1,1)
export var color_frontbumper = Color(1,1,1)
export var color_backbumper = Color(1,1,1)
export var color_grill = Color(1,1,1)
export var color_inside = Color(1,1,1)
export var color_window = Color8(0,139,139)
export var color_rearlight = Color8(252,84,84)
export var color_headlight = Color(1,1,1)
export var color_turnlight = Color8(252,252,84)
export var color_wheelLB = Color(1,1,1)
export var color_wheelLF = Color(1,1,1)
export var color_wheelRB = Color(1,1,1)
export var color_wheelRF = Color(1,1,1)
export var color_plate = Color8(168,168,168)

func paint_it():
	for n in $model.get_children():
		if n.is_in_group("color_window"):
			n.modulate = n.original_color * color_window
		
		elif n.is_in_group("color_top"):
			n.modulate = n.original_color * color_top
		
		elif n.is_in_group("color_inside"):
			n.modulate = n.original_color * color_inside
		
		elif n.is_in_group("color_sideL"):
			n.modulate = n.original_color * color_sideL
		
		elif n.is_in_group("color_sideR"):
			n.modulate = n.original_color * color_sideR
		
		elif n.is_in_group("color_front"):
			n.modulate = n.original_color * color_front
		
		elif n.is_in_group("color_back"):
			n.modulate = n.original_color * color_back
		
		elif n.is_in_group("color_hood"):
			n.modulate = n.original_color * color_hood 
		
		elif n.is_in_group("color_trunk"):
			n.modulate = n.original_color * color_trunk
		
		elif n.is_in_group("color_rearlight"):
			n.modulate = n.original_color * color_rearlight
		
		elif n.is_in_group("color_headlight"):
			n.modulate = n.original_color * color_headlight
		
		elif n.is_in_group("color_wheelLB"):
			n.modulate = n.original_color * color_wheelLB
		
		elif n.is_in_group("color_wheelLF"):
			n.modulate = n.original_color * color_wheelLF
		
		elif n.is_in_group("color_wheelRB"):
			n.modulate = n.original_color * color_wheelRB
		
		elif n.is_in_group("color_wheelRF"):
			n.modulate = n.original_color * color_wheelRF
		
		elif n.is_in_group("color_grill"):
			n.modulate = n.original_color * color_grill
		
		elif n.is_in_group("color_frontbumper"):
			n.modulate = n.original_color * color_frontbumper
			
		elif n.is_in_group("color_backbumper"):
			n.modulate = n.original_color * color_backbumper
			
		elif n.is_in_group("color_turnlight"):
			n.modulate = n.original_color * color_turnlight
			
		elif n.is_in_group("color_plate"):
			n.modulate = n.original_color * color_plate
			

onready var wheelsound = $Other
export var head_height = 100
export var engine = 0
export var positionZ = 0
var dontCollideWall = false
var dontCollideSprite = false
var stepover = true
var averages = 0
export var dashboard = "res://assets/car dash escort.png"
export var steeringwheel = "res://assets/car wheel escort.png"
export var steer_pos = Vector2(-74,420)
export var steer_size_divi = 5.8
export var meter_speed_pos = Vector2(-255,336)
export var meter_rpm_pos = Vector2(109,336)
export var gears = 5
var gear_in = 0

var motion = Vector2()

var default_pos = Vector2()

func _ready():
	#if engine == 0: timer_scale = 0.017
	#elif engine == 1: timer_scale = 0.017
	#elif engine == 2: timer_scale = 0.017
	
	add_collision_exception_with($wheel0)
	add_collision_exception_with($wheel1)
	add_collision_exception_with($wheel2)
	add_collision_exception_with($wheel3)
	for n in $model.get_children():
		add_collision_exception_with(n)
	
	default_pos = $model.position
	paint_it()











export var camdist = 500
export var camheight = 80
export(float) var camZdivide = 4


var arr_sprites = []
export var lightFh = 45
export var lightRh = 50


func shoot():
	var instance = load("res://objects/light-sprite.tscn").instance()
	instance.daddy = self
	instance.switch = 0
	instance.spr_height = lightFh
	add_collision_exception_with(instance)
	arr_sprites.push_back(instance)
	get_parent().add_child(instance)
	
	instance = load("res://objects/light-sprite.tscn").instance()
	instance.daddy = self
	instance.switch = 1
	instance.spr_height = lightFh
	add_collision_exception_with(instance)
	arr_sprites.push_back(instance)
	get_parent().add_child(instance)
	
	instance = load("res://objects/light-sprite.tscn").instance()
	instance.daddy = self
	instance.switch = 2
	instance.spr_height = lightRh
	instance.modulate = Color(0.5,0,0,0.5)
	add_collision_exception_with(instance)
	arr_sprites.push_back(instance)
	get_parent().add_child(instance)
	
	instance = load("res://objects/light-sprite.tscn").instance()
	instance.daddy = self
	instance.switch = 3
	instance.spr_height = lightRh
	instance.modulate = Color(0.5,0,0,0.5)
	add_collision_exception_with(instance)
	arr_sprites.push_back(instance)
	get_parent().add_child(instance)
	
#	instance = load("res://objects/driver-sprite.tscn").instance()
#	instance.daddy = self
#	instance.switch = 4
#	instance.spr_height = 50
#	add_collision_exception_with(instance)
#	arr_sprites.push_back(instance)
#	get_parent().add_child(instance)







var lightFT = Vector2()
var lightFB = Vector2()
var lightRT = Vector2()
var lightRB = Vector2()
#var driver = Vector2()
#var seatFT = Vector2()
#var seatFB = Vector2()
#var seatRT = Vector2()
#var seatRB = Vector2()

var lightshit = false

func _process(_delta):
	if lightshit == false:
		shoot()
		lightshit = true
	
	lightFT = position + ($lightFT.position*scale).rotated(deg2rad(rotation_degrees))
	lightFB = position + ($lightFB.position*scale).rotated(deg2rad(rotation_degrees))
	lightRT = position + ($lightRT.position*scale).rotated(deg2rad(rotation_degrees))
	lightRB = position + ($lightRB.position*scale).rotated(deg2rad(rotation_degrees))
	#driver = position + ($driver.position*scale).rotated(deg2rad(rotation_degrees))
	
	var average = (to_global($model/base.points[2]) + to_global($model/base.points[3]))/2
	
	darkness = ($wheel0.darkness + $wheel1.darkness + $wheel2.darkness + $wheel3.darkness)/4
	if darkness != was_darkness:
		for n in $model.get_children():
			n.darkness = darkness
			
		was_darkness = darkness
	
	for n in arr_sprites.size():
		arr_sprites[n].positionZ = theraot(
			Vector3(to_global(arr_sprites[n].position).x, to_global(arr_sprites[n].position).y, arr_sprites[n].positionZ),
			Vector3(to_global($model/base.points[0]).x, to_global($model/base.points[0]).y, $model/base.heights[0] + $model/base.extraZ[0] +$model.offset),
			Vector3(to_global($model/base.points[1]).x, to_global($model/base.points[1]).y, $model/base.heights[1] + $model/base.extraZ[1] +$model.offset), 
			Vector3(average.x, average.y, ((($model/base.heights[2] + $model/base.extraZ[2]) + ($model/base.heights[3] + $model/base.extraZ[3]))/2 +$model.offset) ))#############
	
	
	
	#$Engine.pitch_scale = 1 + (motion.length()/max_speed)
	$Engine.pitch_scale = 1 + (motion.length()/abs(max_speed/(float(gears)/not_zero(gear_in))))
	
	#print(transform.x.length(), "    ",transform.y.length())
	if (motion.length() > 0) && (rotation_degrees + 180)-rad2deg(motion.angle() + PI) > 10:
		$Tire.pitch_scale = 0.9 + (motion.length()/max_speed)/5
		$Tire.car_tire_skid()
	else:
		$Tire.stop()
	
	if (Worldconfig.playercar != self) or (Worldconfig.menu != null): #GE-GE OUT
		motion = lerp(motion, Vector2(), 0.1)
	else:
		#print(sign(motion.length()))
		#print(rotation_degrees + 180,"    ",rad2deg(motion.angle() + PI))
		#print((rotation_degrees + 180)-rad2deg(motion.angle() + PI))
		if Input.is_action_just_pressed("ply_car_radio"):
			if $Radio.playing == true:
				$Radio.stop()
			else:
				$Radio.radio()
		
		#$Engine.car_engine_loop()
		if !Worldconfig.player.camera && Worldconfig.player.guninv != -1:
			Worldconfig.player.rotation_angle = rad_overflow(deg2rad(rotation_degrees+turn)-PI/2)
			Worldconfig.player.guninv = -1
			Worldconfig.player.gunswitch()
		
#		if Input.is_action_just_pressed("ply_use"):
#			Worldconfig.player.position = position - Vector2(0,150).rotated(deg2rad(rotation_degrees))
#			Worldconfig.player.noclip = false
#			$model.scale = default_pos
#			Worldconfig.player.vroll_car = 0
#			Worldconfig.playercar = null
			
			
		else:
			if motion.length() > 10:
				Worldconfig.player.vbob += motion.length()/10000
			
			
			
			
			if Worldconfig.player.camera:
				Worldconfig.player.positionZ = ($wheel0.positionZ + $wheel1.positionZ + $wheel2.positionZ + $wheel3.positionZ)/camZdivide + camheight
				Worldconfig.player.lookingZ = lerp(Worldconfig.player.lookingZ, -abs(-float((($wheel0.positionZ+$wheel1.positionZ)/2)-(($wheel3.positionZ+$wheel2.positionZ)/2))/1500), 0.1)
				Worldconfig.player.vroll_car = 0
				$model.position = default_pos
				
				if !Worldconfig.player.map_on:
					if Input.is_action_pressed("ply_lookleft") && Input.is_action_pressed("ply_lookright"):
						Worldconfig.player.position = position - Vector2(-camdist, 0).rotated(deg2rad(rotation_degrees))
						Worldconfig.player.rotation_angle = lerp_angle(Worldconfig.player.rotation_angle,  rad_overflow(deg2rad(rotation_degrees)+PI/2),  0.8)
					
					elif Input.is_action_pressed("ply_lookleft"):
						Worldconfig.player.position = position - Vector2(0, -camdist/2).rotated(deg2rad(rotation_degrees))
						Worldconfig.player.rotation_angle = lerp_angle(Worldconfig.player.rotation_angle,  rad_overflow(deg2rad(rotation_degrees)-deg2rad(150)),  0.8)
						
					elif Input.is_action_pressed("ply_lookright"):
						Worldconfig.player.position = position - Vector2(0,camdist/2).rotated(deg2rad(rotation_degrees))
						Worldconfig.player.rotation_angle = lerp_angle(Worldconfig.player.rotation_angle,  rad_overflow(deg2rad(rotation_degrees)-deg2rad(25)),  0.8)
						
					else:
						Worldconfig.player.position = position - Vector2(camdist,0).rotated(deg2rad(rotation_degrees))
						Worldconfig.player.rotation_angle = rad_overflow(deg2rad(rotation_degrees+turn)-PI/2)
				else:
					Worldconfig.player.position = position
				
				
				
			else:
				if !Worldconfig.player.map_on:
					Worldconfig.player.position = to_global($driver.position)#position - Vector2(0,50).rotated(deg2rad(rotation_degrees))
					$model.position = Vector2(0,-99999)
				else:
					Worldconfig.player.position = position
					$model.position = default_pos
				
				Worldconfig.player.positionZ = (($wheel0.positionZ + $wheel1.positionZ + $wheel2.positionZ + $wheel3.positionZ)/4) + driver_height
				Worldconfig.player.lookingZ = -float((($wheel0.positionZ+$wheel1.positionZ)/2)-(($wheel3.positionZ+$wheel2.positionZ)/2))/1000
				
				
				if Input.is_action_pressed("ply_lookleft"):
					Worldconfig.player.rotation_angle = lerp_angle(Worldconfig.player.rotation_angle,  rad_overflow(deg2rad(rotation_degrees)-deg2rad(150)),  0.8)
					Worldconfig.player.vroll_car = lerp(Worldconfig.player.vroll_car, ((($wheel2.positionZ+$wheel3.positionZ)/2) - (($wheel0.positionZ+$wheel1.positionZ)/2))/9, 0.8)
					
				elif Input.is_action_pressed("ply_lookright"):
					Worldconfig.player.rotation_angle = lerp_angle(Worldconfig.player.rotation_angle,  rad_overflow(deg2rad(rotation_degrees)-deg2rad(25)),  0.8)
					Worldconfig.player.vroll_car = lerp(Worldconfig.player.vroll_car, ((($wheel0.positionZ+$wheel1.positionZ)/2) - (($wheel2.positionZ+$wheel3.positionZ)/2))/9, 0.8)
					
				else:
					Worldconfig.player.rotation_angle = lerp_angle(Worldconfig.player.rotation_angle,  rad_overflow(deg2rad(rotation_degrees)-PI/2),  0.8)
					Worldconfig.player.vroll_car = ((($wheel0.positionZ+$wheel3.positionZ)/2) - (($wheel1.positionZ+$wheel2.positionZ)/2))/4
					
				
				
				#$model.position = default_pos
				
	
	
	
	
	
	
	

export var driver_height = 0



func theraot(v0,v1,v2,v3):
	var normal = (v2 - v1).cross(v3 - v1).normalized()
	var dir = Vector3(0.0, 0.0, 1.0)
	var r = v0 + dir * ((v1.dot(normal)) - v0.dot(normal)) / dir.dot(normal)
	
	return r.z

#var timer = 1
#var timer_scale = 0.017

func _physics_process(delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	if (Worldconfig.playercar == self) && (Worldconfig.menu == null):
		move_and_steer(delta)
		
		#if $Engine.stream != $Engine.car0F:
		if !$Engine.carFs.has($Engine.stream):
			if !$Engine.playing:
				$Engine.car_engine_loop()
		else:
			$Engine.car_engine_start()
		
		#if timer <= 0:
		#	$Engine.car_engine_loop()
		#	timer = $Engine.stream.get_length()
		#else:
		#	timer -= 0 * $Engine.pitch_scale
	
	
	
	$model/base.extraZ[0] = $wheel0.positionZ
	$model/base.extraZ[1] = $wheel1.positionZ
	$model/base.extraZ[2] = $wheel2.positionZ
	$model/base.extraZ[3] = $wheel3.positionZ
	
	
	
	
	positionZ = ($wheel0.positionZ + $wheel1.positionZ + $wheel2.positionZ + $wheel3.positionZ)/4
	#positionZ = [$wheel0.positionZ, $wheel1.positionZ, $wheel2.positionZ, $wheel3.positionZ].min()
	
	#head_height = [$wheel0.positionZ, $wheel1.positionZ, $wheel2.positionZ, $wheel3.positionZ].min() - [$wheel0.positionZ, $wheel1.positionZ, $wheel2.positionZ, $wheel3.positionZ].max()
	
	
	
	if Worldconfig.playercar == self && (Worldconfig.menu == null): #GE-GE OUT
		if Input.is_action_just_pressed("ply_use"):
			$Engine.car_engine_off()
			Worldconfig.player.position = position - Vector2(0,150).rotated(deg2rad(rotation_degrees))
			Worldconfig.player.noclip = false
			$model.position = default_pos
			Worldconfig.player.vroll_car = 0
			Worldconfig.playercar = null




export var wheel_base = 70  # Distance from front to rear wheel
export var steer_multi = 15  # Amount that front wheel turns, in degrees
#export(float) var steer_max = 1.5
var steer_max = 1.5
export(float) var steer_rate = 0.075

export(float) var engine_power = 8  
export var break_power = 16
export var max_speed = 140

var steer_angle
var turn = 0
var traction = 0.1

func move_and_steer(delta):
	if abs(turn) > steer_max:
		turn = steer_max*sign(turn)
	
	if Input.is_action_pressed("ply_right"):
		turn += steer_rate * Worldconfig.player.steer_sensibility
	elif Input.is_action_pressed("ply_left"):
		turn -= steer_rate * Worldconfig.player.steer_sensibility
	else:
		turn = lerp(turn, 0, 0.5)
	steer_angle = turn * deg2rad(steer_multi)
	
	#motion = Vector2.ZERO
	
	if Input.is_action_just_pressed("ply_car_gear"):
		if Input.is_action_pressed("ply_car_gearup") && (gear_in < gears):
			gear_in += 1
		elif Input.is_action_pressed("ply_car_geardown") && (gear_in > -1):
			if motion.length() < 1: gear_in = -1
			else: gear_in -= 1
		
	elif Input.is_action_pressed("ply_car_gear"):
		if Input.is_action_just_pressed("ply_car_gearup") && (gear_in < gears):
			gear_in += 1
		elif Input.is_action_just_pressed("ply_car_geardown") && (gear_in > -1):
			if motion.length() < 1: gear_in = -1
			else: gear_in -= 1
	
	else:
		if Input.is_action_pressed("ply_up") && gear_in != 0:
			#print(max_speed/(gears/gear_in),"   ",max_speed,"    ",float(gears)/gear_in)
			if (motion.length() < max_speed/(float(gears)/gear_in)) or gear_in == -1:
				if ($wheel0.on_floor == true) or ($wheel1.on_floor == true):
					if ($wheel0.on_floor) != ($wheel1.on_floor):
						if gear_in == -1: motion -= transform.x*(engine_power/2)*10
						else: motion += transform.x*(engine_power/2)/(gear_in)
					else:#if ($wheel0.on_floor != false) && ($wheel1.on_floor != false):
						if gear_in == -1: motion -= (transform.x*engine_power)*10
						else: motion += transform.x*engine_power
		
		
		elif Input.is_action_pressed("ply_down"):
			if ($wheel0.on_floor == true) or ($wheel1.on_floor == true):
				if (motion.length() > (transform.x.length()*(break_power))):
					if ($wheel0.on_floor) != ($wheel1.on_floor):
						motion -= transform.x*(break_power)/2
					else:
						motion -= transform.x*break_power
					
					#if motion.length() > 0:
					#	$Other.car_tire_skid()
					
				else:
					motion = Vector2(0,0)
			#if motion.length() < 10:
			#	motion = Vector2(0,0)
	
	#print(transform)
	
	
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	
	if ($wheel0.on_floor == true) or ($wheel1.on_floor == true):
		if ($wheel0.on_floor) != ($wheel1.on_floor):
			rear_wheel += (motion * delta)/2
		else:
			rear_wheel += motion * delta
	if ($wheel2.on_floor == true) or ($wheel3.on_floor == true): ## &&
		if ($wheel2.on_floor) != ($wheel3.on_floor):
			front_wheel += (motion.rotated(steer_angle) * delta)/2
		else:
			front_wheel += motion.rotated(steer_angle) * delta
	
	
	var new_heading = (front_wheel - rear_wheel).normalized()
	#motion = new_heading * motion.length()
	motion = motion.linear_interpolate(new_heading * motion.length(), traction)
	#velocity.linear_interpolate(new_heading * velocity.length(), traction)
	rotation = new_heading.angle()











var darkness = 1
var was_darkness

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
		if dontCollideWall:
			add_collision_exception_with(col_floors[n])
		
		else:
		#if col_floors != null:
			if col_floors[n].flag_1height:
				
				#if col_floors[n].heights[0] < positionZ: #shadow position#
				if col_floors[n].heights[0] - positionZ < compareZ:
					compareZ = col_floors[n].heights[0] - positionZ
				
				
				
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
							motionZ = -motionZ
					
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
	




var col_floors = []
var col_walls = []
var col_sprites = []
var on_floor = false
var on_body = false
var body_on = null
var compareZ = INF
var move_dir = Vector3(0,0,0)
var motionZ = 0

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
	#if body.is_in_group("floor"):
		
		if col_floors.has(body):
			on_floor = false
			col_floors.erase(body)
			compareZ = INF
			
			if (col_floors.size() == 0) && (!dontCollideWall):
				if (positionZ <= Worldconfig.player.min_Z): positionZ = Worldconfig.player.min_Z
			
	
	#if body.is_in_group("wall"):
		elif col_walls.has(body):
			col_walls.erase(body)
	
	#if body.is_in_group("sprite"):
		elif col_sprites.has(body):
			col_sprites.erase(body)
			on_floor = false








func rad_overflow(N):
	if N > PI*2:
		N -= PI*2
	elif N < 0:
		N += PI*2
	
	return N

func deg_overflow(N):
	if N > 360:
		N -= 360
	elif N < 360:
		N += 360
	
	return N

func not_zero(busta):
	if busta == 0:
		busta = 1
	
	return busta
