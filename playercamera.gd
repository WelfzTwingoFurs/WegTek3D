extends KinematicBody2D
#OS.get_system_time_msecs()

var motion = Vector2()

export var camera = false
export var noclip = false

export var angles = 145
export var draw_distance = 10000

export var rotate_rate = 3.0
export var speed = 1500


export(float) var GRAVITY = 0.5
export(float) var JUMP = 10
export var head_height = 100

export var positionZ = 0
export var min_Z = 0

export var vbob_max = 4.0
export var vbob_speed = 0.09
export var vroll_multi = -1.5

export var map_draw = 2

export var skycolor = Color8(47,0,77)
export var scenetint = Color8(255,255,255)
export var sky_stretch = Vector2(1,1)
export(float) var bg_offset = 1
#Used for sky & floor position according to draw_distance

export(bool) var cull_on = 1
export(bool) var textures_on = true
export var higfx = false
export(bool) var shading = true
export(bool) var sprite_shadows = true

onready var change_checker = []

func _ready():
	Worldconfig.player = self
	Worldconfig.Camera2D = $Camera2D
	
	$Background.visible = 1
	#$View/Feet.visible = 1
	#Turn everything on
	
	$ViewArea/ViewCol.polygon = [Vector2(0,0),   Vector2(0,draw_distance*2).rotated(-deg_rad(angles/2)),   Vector2(0,draw_distance*2).rotated( deg_rad(angles/2))]
	change_checker = [$View/Feet.texture, $Background/Sky.texture, $Background/Floor.texture, 0, draw_distance, angles, OS.window_size*0, sky_stretch, Color8(255,255,255)]
	#Checks if things changed and updates
	

########        ############        ####        ########        ####    ####
####    ####    ####            ####    ####    ####    ####    ####    ####
########        ########        ############    ####    ####    ############
####    ####    ####            ####    ####    ####    ####        ####
####    ####    ############    ####    ####    ########            ####

################################################################################
################################################################################
################################################################################
################################################################################
################################################################################










var rotation_angle = 0

var input_dir = Vector2(0,0)
var move_dir = Vector3(0,0,0)

var vbob = 0
var vroll_strafe_divi = 1 #changes if strafing

var posZlookZ = 0
var lookingZ = 0
#View pans up and down

var mouselock = false
var mousedir = Vector2(0,0)

func _input(event):
	if mouselock:
		if event is InputEventMouseMotion:
			mousedir = event.relative
			
			if (lookingZ < $PolyContainer.scale.y*10) or (lookingZ > -$PolyContainer.scale.y*10):
				lookingZ -= ($PolyContainer.scale.y/50)*mousedir.y
			rotation_angle += 0.0174533 * mousedir.x
			rotation_angle = rad_overflow(rotation_angle)
			
		else:
			mousedir = Vector2(0,0)



func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = Vector2(speed*move_dir.x, speed*move_dir.y).rotated(rotation_angle)
	$ViewArea/ViewCol.rotation_degrees = rad_deg(rotation_angle) #radian to degrees
	 
	if !camera:
		if Input.is_action_pressed("ply_up"):
			input_dir.y = 1
			move_dir.y = 1
		
		elif Input.is_action_pressed("ply_down"):
			input_dir.y = -1
			move_dir.y = -1
		
		else: #no inputs
			input_dir.y = 0
			move_dir.y = 0
		
		
		if Input.is_action_pressed("ply_left"):
			input_dir.x = 1
			
			if Input.is_action_pressed("ply_strafe") or mouselock: #strafe
				move_dir.x = 1
				vroll_strafe_divi = 1
				
			else:
				vroll_strafe_divi = 1.3
				move_dir.x = 0
				
				rotation_angle -= 0.0174533 * rotate_rate #1 degree in radian
		
		
		elif Input.is_action_pressed("ply_right"):
			input_dir.x = -1
			
			if Input.is_action_pressed("ply_strafe") or mouselock: #strafe
				move_dir.x = -1
				vroll_strafe_divi = 1
				
			else:
				vroll_strafe_divi = 1.3
				move_dir.x = 0
				
				rotation_angle += 0.0174533 * rotate_rate #1 degree in radian
		
		
		else: #no inputs
			input_dir.x = 0
			move_dir.x = 0
		
		
		
		if Input.is_action_pressed("bug_rotatecenter"):
			move_dir = Vector3(0,0,0)
			
			#print(rotation_angle," = ", rad_deg(rotation_angle))
			
			
			if abs(input_dir.x) != abs(input_dir.y):
				if input_dir.y == -1: #down
					rotation_angle = 0 - 0.000001
				
				elif input_dir.y == 1: #up
					rotation_angle = PI - 0.000001
				
				elif input_dir.x == 1: #left
					rotation_angle = 0.5*PI - 0.000001
				
				elif input_dir.x == -1: #right
					rotation_angle = 1.5*PI - 0.000001
				
			
			else:
				if input_dir.y == -1: #down
					if input_dir.x == 0:
						rotation_angle = 0
					elif input_dir.x == 1:
						rotation_angle = deg_rad(45)
					elif input_dir.x == -1:
						rotation_angle = deg_rad(315)
				
				elif input_dir.y == 1: #up
					if input_dir.x == 0:
						rotation_angle = PI
					elif input_dir.x == 1:
						rotation_angle = deg_rad(135)
					elif input_dir.x == -1:
						rotation_angle = deg_rad(225)
		
		
		
		############################################################################
		############################################################################
		#Z inputs & math
		if !mouselock:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if Input.is_action_pressed("ply_lookup"): #3.6 won't cut it with the new Y-FOV stretching!
				if lookingZ < $PolyContainer.scale.y*10:
					lookingZ += rotate_rate*0.01 #* Engine.time_scale
			elif Input.is_action_pressed("ply_lookdown"):
				if lookingZ > -$PolyContainer.scale.y*10:
					lookingZ -= rotate_rate*0.01 #* Engine.time_scale
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		
		#mousedir = lerp(mousedir, Vector2(0,0), 1)
		
		if Input.is_action_just_pressed("bug_lockmouse"):
			mouselock = !mouselock
		
		if Input.is_action_pressed("ply_lookcenter"):
			lookingZ = lerp(lookingZ, 0, 0.1)
	
	if abs(lookingZ) > $PolyContainer.scale.y*10:# don't overflow
		lookingZ = ($PolyContainer.scale.y*10) * sign(lookingZ)
	
	#posZlookZ = OS.window_size.y*(positionZ/draw_distance/10) + OS.window_size.y*lookingZ
	posZlookZ = ( (OS.window_size.y*(positionZ/not_zero(draw_distance*bg_offset)/10)) * ($PolyContainer.scale.y*10) )  +  OS.window_size.y*lookingZ
	#Used for sky & floor position according to draw_distance
	
	
	#if col_floors.size() != 0:
	if Input.is_action_just_pressed("ply_noclip"):
		noclip = !noclip
		$Col.disabled = !$Col.disabled
		on_floor = false
	
	if !noclip && !camera:
		collide()
		
		if on_body == true:
			motionZ = 0
			positionZ = body_on.positionZ + body_on.head_height
			if Input.is_action_pressed("ply_jump"):
				motionZ += JUMP
				on_body = false
			if col_sprites.size() == 0:
				on_body = false
		
		if on_floor == true:
			motionZ = 0
			if Input.is_action_pressed("ply_jump"):
				motionZ += JUMP
				on_floor = false
		
		else:
			if (col_floors.size() == 0 && positionZ <= min_Z):
				on_floor = true
				motionZ = 0
			elif positionZ > min_Z:
				motionZ -= GRAVITY
			else:
				on_floor = true
				motionZ = 0
		
		positionZ += motionZ
	
	#elif (col_floors.size() == 0 && positionZ <= 0):
	#	motionZ = 0
	#	on_floor = true
	
	elif !camera:
		motionZ = 0
		if Input.is_action_pressed("ply_jump"):
			positionZ += 1 * rotate_rate * Engine.time_scale
			move_dir.z = 1
		elif Input.is_action_pressed("ply_crouch"):
			positionZ -= 1 * rotate_rate * Engine.time_scale
			move_dir.z = -1
		elif Input.is_action_pressed("ply_flycenter"):
			positionZ = lerp(positionZ, 0-head_height, 0.1)
		else:
			move_dir.z = 0
	#print(positionZ)
	#print(lookingZ)
	
	############################################################################
	
	if Input.is_action_just_pressed("ply_wpn_next"):
		guninv += 1
		if guninv > 3: guninv = 0
		gunswitch()
	elif Input.is_action_just_pressed("ply_wpn_previous"):
		guninv -= 1
		if guninv < 0: guninv = 3
		gunswitch()
	
	if Input.is_action_pressed("ply_wpn_fire1"):
		gunfire(false)
	if Input.is_action_just_released("ply_wpn_fire1"):
		gunstop(false)
	
	if Input.is_action_pressed("ply_wpn_fire2"):
		gunfire(true)
	if Input.is_action_just_released("ply_wpn_fire2"):
		gunstop(true)
	
	if Input.is_action_just_pressed("bug_camera"):
		camera = !camera
	
	###   ######      ######   ###   ###   #########
	###   ###   ###   ##  ##   ###   ###      ###
	###   ###   ###   ######   ###   ###      ###
	###   ###   ###   ###      #########      ###
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	# ^^ Input, motion, rotation
	
	
	if motionZ < 0:
		move_dir.z = -1
	elif motionZ > 0:
		move_dir.z = 1
	elif motionZ == 0:
		move_dir.z = 0
	
	if Worldconfig.zoom < 2:
		#$View/Hand.position.x = 0#(get_viewport().size.x/2) - (($View/Hand.texture.get_size().x/$View/Hand.hframes)*gunscale)/2
		#$View/Hand.position.x = get_viewport().get_mouse_position().x - (($View/Hand.texture.get_size().x/$View/Hand.hframes)*$View/Hand.scale.x)
		$View/Hand.position.x = lerp($View/Hand.position.x, abs(vbob*10)*-input_dir.x, 0.01)
		
		$View/Hand.position.y = lerp($View/Hand.position.y, (get_viewport().size.y/2) - (($View/Hand.texture.get_size().y/$View/Hand.vframes)*gunscale)/2 + abs(vbob)*vbob_max + abs(input_dir.x)*30 +lookingZ*5 +($PolyContainer.scale.y*50), 0.5) 
		$View/Hand.rotation_degrees = lerp($View/Hand.rotation_degrees, -input_dir.x*(vroll_strafe_divi)*-vroll_multi, 0.5)
		
		if !gunstretch:
			$View/Hand.scale = Vector2(gunscale,gunscale)
		else:
			$View/Hand.scale.x = OS.window_size.x/$View/Hand.texture.get_width()
			$View/Hand.scale.y = gunscale
	
	#Worldconfig.playeraim = positionZ + head_height +((lookingZ/($PolyContainer.scale.y*10))*450)
	
	##  ##    ##    ####    ####
	##  ##  ##  ##  ##  ##  ##  ##
	######  ######  ##  ##  ##  ##
	##  ##  ##  ##  ##  ##  ##  ##
	##  ##  ##  ##  ##  ##  ####
	
	
	
	
	
	# vv Sprite effects, vbob
	########################################################################################################################################################
	########################################################################################################################################################
	if !camera:
		if move_dir != Vector3(0,0,0):
			if move_dir.y == 1:
				vbob += vbob_speed
			else:
				vbob -= vbob_speed
		
		else:
			if vbob != 0:
				vbob = stepify(lerp(vbob,0,0.1),0.1)
	
	
	if vbob > vbob_max:
		vbob = -vbob_max
	elif vbob < -vbob_max:
		vbob = vbob_max
	
	##  ##  ####      ##    ####     ##    ##    ###    ###  ###  ###  ###
	##  ##  ##  ##  ##  ##  ##  ##   # ##  # #  #   #  #     #    #    #
	##  ##  ####    ##  ##  ####     ##    ##   #   #  #     ###  ###  ###
	##  ##  ##  ##  ##  ##  ##  ##   #     # #  #   #  #     #      #    #
	  ##    ####      ##    ####     #     # #   ###    ###  ###  ###  ###
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	#vbob and vroll
	#position.y = abs(vbob)
	
	$PolyContainer.position.y = OS.window_size.y*lookingZ + abs(vbob)
	$PolyContainer.rotation_degrees = lerp($PolyContainer.rotation_degrees, (-input_dir.x*vroll_multi),00.1)/vroll_strafe_divi
	$Background.rotation_degrees = $PolyContainer.rotation_degrees
	
	
	########################################################################################################################################################
	if sky_stretch.y > 0:
		$Background/Sky.rect_position.y = ($Background/Sky.rect_size.y/not_zero(OS.window_size.y)) +vbob_max +posZlookZ + abs(vbob)
		
	else:
		$Background/Sky.rect_position.y = -$Background/Sky.rect_size.y +vbob_max +posZlookZ + abs(vbob)
	
	if sky_stretch.x > 0:
		$Background/Sky.rect_position.x = (-OS.window_size.x/2) - ($ViewArea/ViewCol.rotation_degrees*(float(OS.window_size.x)/360))
		
	else:
		$Background/Sky.rect_position.x = (-OS.window_size.x/2) - ( $ViewArea/ViewCol.rotation_degrees*(float($Background/Sky.texture.get_width())/360) ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	
	
	
	########################################################################################################################################################
	if sign($Background/Floor.position.y/not_zero(OS.window_size.y)) < 0:         #Floor doesn't stretch until looking down limit, it ends around when Sky is out of view
		VisualServer.set_default_clear_color($Background/Floor.modulate)# and changes the skycolor to its color when that limit is reached
	else:
		VisualServer.set_default_clear_color(skycolor)
	
	
	$Background/Floor.position.y = OS.window_size.y+posZlookZ + abs(vbob)
	#Floor.scale = Vector2( (OS.window_size.x/Floor.texture.get_width())+1+lookZscale,    (OS.window_size.y/(Floor.texture.get_height()/2))  ) 
	
	########################################################################################################################################################
	########################################################################################################################################################
	
	####      ####      ####    ####      ##      ##  ####  ####  ####
	##  ##  ##          ##  ##  ##  ##  ##  ##  ##    ##    ##    ##
	####    ##  ####    ####    ####    ##  ##  ##    ####  ####  ####
	##  ##  ##    ##    ##      ##  ##  ##  ##  ##    ##      ##    ##
	####      ####      ##      ##  ##    ##      ##  ####  ####  ####
	
	
	var C = float(1)
	if darkness < 0: C *= -darkness
	elif darkness > 0: C /= darkness
	$View.modulate = Color(C,C,C)*scenetint
	
	
	
	if lookingZ < 0:
		#var percent = -(lookingZ/$PolyContainer.scale.y*10)/100
		#$View/Feet.scale.y = OS.window_size.y/$View/Feet.texture.get_height() * percent
		#$View/Feet.position.y = ((get_viewport().size.y/2) - (get_viewport().size.y/2)*percent) + (1-percent)*100# + $PolyContainer.position.y - $PolyContainer.scale.y*10
		
		$View/Feet.scale.y = OS.window_size.y/$View/Feet.texture.get_height()
		$View/Feet.position.y = -((OS.window_size.y*-$PolyContainer.scale.y*10) - $PolyContainer.position.y)
		
		
		
		$View/Feet.visible = 1
		#$View/Feet.rotation_degrees = -input_dir.x*vroll_strafe_divi*2
		#feetY = $View/Feet.position.y
		
		if on_floor or on_body:
			if input_dir.y != 0:
				$View/AniPlayFeet.play("walk")
				$View/AniPlayFeet.playback_speed = input_dir.y

			elif input_dir.x != 0:
				if Input.is_action_pressed("ply_strafe"):
					if input_dir.x == -1:
						$View/AniPlayFeet.play("strafeR")
					else:
						$View/AniPlayFeet.play("strafeL")

				else:
					$View/AniPlayFeet.play("spin")
					$View/AniPlayFeet.playback_speed = input_dir.x


			else:
				$View/Feet.frame = 0
				$View/AniPlayFeet.stop()
		else:
			$View/AniPlayFeet.stop()
			if move_dir.z == 1:
				$View/Feet.frame = 7
			else:# move_dir.z == -1:
				$View/Feet.frame = 8
		
	else:
		$View/Feet.visible = 0
		$View/AniPlayFeet.stop()
	
	########  ########  ########  ########
	####      ####      ####        ####
	######    ########  ######      ####
	####      ####      ####        ####
	####      ########  ########    ####
	
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################
	########################################################################################################################################################

func _process(_delta):
	if rotation_angle < 0:
		rotation_angle = 2*PI #360 in radian

	if rotation_angle > 2*PI: #360 in radian
		rotation_angle = 0
	
	
	if change_checker != [$View/Feet.texture, $Background/Sky.texture, $Background/Floor.texture, 0, draw_distance, angles, OS.window_size, sky_stretch, scenetint]:
		recalculate()
	else:
		if Input.is_action_pressed("bug_closeeyes"):
			$Background.visible = 0
			$View.visible = 0
			VisualServer.set_default_clear_color(0)
			update()
			if (weakref(new_container).get_ref()):
				new_container.queue_free()
			
		elif Input.is_action_just_released("bug_closeeyes"):
			update()
			$Background.visible = 1
			$View.visible = 1
		
		else:
			render()

#####    #####      #####      #####  ##########   ##########  #########
##   ##  ##   ##  ##     ##  ##       ##           ###         ###
##   ##  ##   ##  ##     ##  ##       ##           ###         ###
#####    #####    ##     ##  ##       ##########   ##########  #########
##       ##   ##  ##     ##  ##       ##                  ###         ##
##       ##   ##  ##     ##  ##       ##                  ###         ##
##       ##   ##    #####      #####  ##########   ##########  #########

################################################################################
################################################################################
################################################################################
################################################################################

var guninv = 0
export var gunscale = 3
export(bool) var gunstretch = false
export var feet1 = preload("res://assets/feet1.png")
export var feet2 = preload("res://assets/feet2.png")


func gunswitch():
	print(guninv)
	if guninv == 0:
		$View/Hand.visible = 0
		$View/Feet.texture = feet1
	else:
		$View/Hand.visible = 1
		$View/Feet.texture = feet2
	
	if guninv == 1:
		$View/Hand.texture = load("res://assets/weapon handgun.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 2
	elif guninv == 2:
		$View/Hand.texture = load("res://assets/weapon flamethrower.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 7
	elif guninv == 3:
		$View/Hand.texture = load("res://assets/weapon doomarms.png")
		$View/Hand.hframes = 1
		$View/Hand.vframes = 1

func gunfire(alt):
	if guninv == 1:
		
		if Input.is_action_just_pressed("ply_wpn_fire1") or Input.is_action_just_pressed("ply_wpn_fire2"):
			shoot()
			$View/AniPlayHand.play("hand-fire")
	
	elif guninv == 2:
		if $View/Hand.frame == 5 or $View/Hand.frame == 4 or $View/Hand.frame == 3 or $View/Hand.frame == 2: darkness = 1
		
		if !alt && Input.is_action_just_pressed("ply_wpn_fire1") && ($View/Hand.frame != 4 or $View/Hand.frame != 3):
			if $View/AniPlayHand.current_animation == "flame-no":
				$View/AniPlayHand.play("flame-fire")
			else:
				$View/AniPlayHand.play("flame-start")
		elif alt:
			if $View/AniPlayHand.current_animation == "flame-start" or $View/AniPlayHand.current_animation == "flame-fire":
				$View/AniPlayHand.play("flame-fire")
			else:
				$View/AniPlayHand.play("flame-no")
				
	elif guninv == 3:
		if Input.is_action_just_pressed("ply_wpn_fire1") or Input.is_action_just_pressed("ply_wpn_fire2"): shoot()

func gunstop(alt):
	if guninv == 2:
		if alt && $View/AniPlayHand.current_animation == "flame-fire":
			$View/AniPlayHand.play("flame-end")
			$View/AniPlayHand.play("flame-end")
		elif $View/AniPlayHand.current_animation == "flame-no":
			$View/Hand.frame = 0


const shot = preload("res://objects/projectile.tscn")
#const shot = preload("res://chaser.tscn")
func shoot():
	if guninv == 1:
		var shoot_instance = shot.instance()
		shoot_instance.rotation_degrees = rotation_angle + PI/2
		shoot_instance.positionZ = positionZ + head_height +((lookingZ/($PolyContainer.scale.y*10))*450)
		shoot_instance.motionZ = (lookingZ/($PolyContainer.scale.y*10))*117#*59
		shoot_instance.speed = 700#350
		
		shoot_instance.position = position + Vector2(50,0).rotated(rotation_angle + PI/2)
		if Input.is_action_just_pressed("ply_wpn_fire2"):
			shoot_instance.dontCollideWall = false
			#shoot_instance.dontCollideSprite = false
		
		get_parent().add_child(shoot_instance)
	
	elif guninv == 3:
		var uno = load("res://objects/car Uno.tscn").instance()
		uno.position = position + Vector2(50,0).rotated(rotation_angle + PI/2)
		get_parent().add_child(uno)







################################################################################
var motionZ = 0

var on_floor = false
var col_floors = []
var col_walls = []
var col_sprites = []



var darkness = 1

var on_body = false
var body_on = null
export var stepover = false

func collide():
	for n in col_sprites.size():
		if col_sprites[n].dontCollideSprite:
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
				if col_sprites[n].stepover && (positionZ < heightsBT.y && positionZ+head_height > heightsBT.y) && (positionZ - heightsBT.y < head_height):#think think think
					positionZ = heightsBT.y
					on_body = true
					body_on = col_sprites[n]
				
				elif col_sprites[n].stepover && (positionZ < heightsBT.x && positionZ+head_height > heightsBT.x) && ((positionZ+head_height) - heightsBT.x < head_height):#think think think
					positionZ = heightsBT.x - head_height -1
				
				else:
					remove_collision_exception_with(col_sprites[n])
			
			else:
				add_collision_exception_with(col_sprites[n])
	
	
	
	for n in col_walls.size():
		#darkness = col_floors[n].darkness
		
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
					on_floor = true
				
				elif col_walls[n].jumpover && (positionZ < heightsBT.x && positionZ+head_height > heightsBT.x) && ((positionZ+head_height) - heightsBT.x < head_height/2):
					positionZ = heightsBT.x - head_height -1
					on_floor = false
				
				else:
					remove_collision_exception_with(col_walls[n])
			
			else:
				add_collision_exception_with(col_walls[n])
	
	for n in col_floors.size():
		darkness = col_floors[n].darkness
		
		if col_floors[n].flag_1height:
			col_proccess(n,col_floors[n].heights[0])
		
		else: #sometimes we gotta process a fuckin slope
			##position at minimum height, that height = margem de erro, margem - player's new height = correct height
#			var margin = col_floors[n].heights.find(col_floors[n].heights.min())
#			var globalpos = col_floors[n].points[margin]# * col_floors[n].scale
#
#			print("index:",margin,"     height:", col_floors[n].heights[margin],"    position:",globalpos)
#
#			if Input.is_action_pressed("mouse1"):
#				position = globalpos
#
#
#			margin = slope(
#				Vector3(globalpos.x, globalpos.y, 0), 
#				Vector3(col_floors[n].points[0].x, col_floors[n].points[0].y, col_floors[n].heights[0]), 
#				Vector3(col_floors[n].points[1].x, col_floors[n].points[1].y, col_floors[n].heights[1]), 
#				Vector3(col_floors[n].points[2].x, col_floors[n].points[2].y, col_floors[n].heights[2]))
#
#
#			print(margin)
			
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




func slope(v0,v1,v2,v3):
	var normal = (v2 - v1).cross(v3 - v1).normalized()
	var dir = Vector3(0.0, 0.0, 1.0)
	var r = v0 + dir * ((v1.dot(normal)) - v0.dot(normal)) / dir.dot(normal)
	
	return r.z
	










func col_proccess(n,col_height):
	if col_floors[n].absolute == -1:
		if positionZ > col_height-1:
			positionZ = col_height - head_height
			on_floor = false
	elif col_floors[n].absolute == 1:
		if positionZ < col_height-head_height:
			positionZ = col_height
			on_floor = true
	
	
	if move_dir.z == -1:
		if (positionZ < col_height) && (positionZ+head_height > col_height):
			positionZ = col_height# + head_height
			
			on_floor = true 
			if motionZ < 0:
				motionZ = 0
				
	
	if move_dir.z == 1:
		if (positionZ < col_height) && (positionZ+head_height > col_height):
			positionZ = col_height - head_height
			
			on_floor = false
			if motionZ > 0:
				motionZ = 0











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
	if body.is_in_group("floor"):
		on_floor = false
		if col_floors.has(body):
			col_floors.erase(body)
			
			if (col_floors.size() == 0):
				if (positionZ <= min_Z): positionZ = min_Z
				darkness = 1
			
	
	if body.is_in_group("wall"):
		if col_walls.has(body):
			col_walls.erase(body)
			
	
	if body.is_in_group("sprite"):
		if col_sprites.has(body):
			col_sprites.erase(body)
			on_body = false
			on_floor = false

######    #######    ###      ###      ###   ######      ######
###      ###   ###   ###      ###            ###   ##    ###
###      ###   ###   ###      ###      ###   ###   ###   #####
###      ###   ###   ###      ###      ###   ###   ##    ###
######    #######    ######   ######   ###   ######      ######

################################################################################
################################################################################
################################################################################
################################################################################











################################################################################

#var feet_stretch = 1

func recalculate():
	if change_checker[0] != $View/Feet.texture or change_checker[6] != OS.window_size:
		$View/Feet.scale.x = OS.window_size.x/$View/Feet.texture.get_width()*10
		
		if change_checker[0] != $View/Feet.texture:
			print("-      TEXTURE: Feet changed")
			change_checker[0] = $View/Feet.texture
			
		
	
	
	if change_checker[1] != $Background/Sky.texture or change_checker[7] != sky_stretch or change_checker[6] != OS.window_size:
		$Background/Sky.rect_size.y = $Background/Sky.texture.get_height()
		#$Background/Sky.rect_size.x = ($Background/Sky.texture.get_width()+OS.window_size.x)
		#$Background/Sky.rect_size.x = $Background/Sky.texture.get_width()*2
		
		
		if sky_stretch.y > 0:
			$Background/Sky.rect_scale.y = ( -(OS.window_size.y/2)/float($Background/Sky.rect_size.y) )*sky_stretch.y
			$Background/Sky.flip_v = 1
		else:
			$Background/Sky.rect_scale.y = 1
			$Background/Sky.flip_v = 0
		
		
		if sky_stretch.x > 0:
			$Background/Sky.rect_size.x = sky_stretch.x*($Background/Sky.texture.get_width())*2
			$Background/Sky.rect_scale.x = (OS.window_size.x/$Background/Sky.texture.get_width())/sky_stretch.x
		else:
			$Background/Sky.rect_size.x = ($Background/Sky.texture.get_width()+OS.window_size.x)
			$Background/Sky.rect_scale.x = 1
		
		
		
		if change_checker[1] != $Background/Sky.texture:
			print("-      TEXTURE: Sky changed")
			change_checker[1] = $Background/Sky.texture
			
		
		
		if sky_stretch.x < 1 && sky_stretch.x != 0 && sky_stretch.x != 0.5:
			print(">M I S T A K E: sky_stretch.x gotta be =0, =0,5, or >1!")
			if sky_stretch.x < 0:
				sky_stretch.x = 0
			else:
				sky_stretch.x = 1
		
		if change_checker[7] != sky_stretch:
			print("-  SKY_STRETCH: ",sky_stretch,", changed from ",change_checker[7])
			change_checker[7] = sky_stretch
			
		
	
	
	if change_checker[2] != $Background/Floor.texture or change_checker[6] != OS.window_size:
		$Background/Floor.scale = Vector2( (OS.window_size.x/$Background/Floor.texture.get_width())+1,    (OS.window_size.y/($Background/Floor.texture.get_height()/2))  )
		#$Background/Floor.scale = Vector2( (OS.window_size.x/$Background/Floor.texture.get_width()) + (abs(vroll_multi)*10),    (OS.window_size.y/($Background/Floor.texture.get_height()/2))  )
		
		
		if change_checker[2] != $Background/Floor.texture:
			print("-      TEXTURE: Floor changed")
			change_checker[2] = $Background/Floor.texture
			
		
	
	
	if change_checker[4] != draw_distance or change_checker[5] != angles or change_checker[6] != OS.window_size:
		var midscreenFirst = OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated(-deg_rad((angles)/2)) ).angle() ))
		var midscreenLast  = OS.window_size.x * (0.25 * tan(( Vector2(0,draw_distance).rotated( deg_rad((angles)/2)) ).angle() ))
		
		$PolyContainer.scale.x = abs(midscreenFirst - midscreenLast)
		$PolyContainer.scale.y = $PolyContainer.scale.x/OS.window_size.y
		
		lookingZ = 0
		
		
		if change_checker[4] != draw_distance or change_checker[5] != angles:
			#$ViewArea/ViewCol.polygon = [Vector2(0,0),Vector2(0,draw_distance).rotated(-deg_rad(angles/2)),Vector2(0,draw_distance).rotated( deg_rad(angles/2))]
			$ViewArea/ViewCol.polygon = [Vector2(0,0),Vector2(0,draw_distance*2).rotated(-deg_rad(angles/2)),Vector2(0,draw_distance*2).rotated( deg_rad(angles/2))]
			
			if change_checker[4] != draw_distance:
				print("-DRAW DISTANCE: ",draw_distance,", changed from ",change_checker[4])
				change_checker[4] = draw_distance
				
			elif change_checker[5] != angles:
				print("- ANGLES (FOV): ",angles,", changed from ",change_checker[5])
				change_checker[5] = angles
		
		
		elif change_checker[6] != OS.window_size:
			print("-   RESOLUTION: ",OS.window_size,", changed from ",change_checker[6])
			change_checker[6] = OS.window_size
		
		
	
	
	if change_checker[8] != scenetint:
		$View.modulate = scenetint
		$PolyContainer.modulate = scenetint
		$Background.modulate = scenetint
		
		print("-    SCENETINT: ",scenetint,", changed from ",change_checker[8])
		change_checker[8] = scenetint



####     ######           ####   ######   ####     ######   ##   ######
##  ##   ##               ##     ##  ##   ##  ##   ##            ##
##  ##   ##               ##     ##  ##   ##  ##   ##            ##
####     ####      ###    ##     ##  ##   ##  ##   ####     ##   ##  ##
##  ##   ##               ##     ##  ##   ##  ##   ##       ##   ##  ##
##  ##   ##               ##     ##  ##   ##  ##   ##       ##   ##  ##
##  ##   ######           ####   ######   ##  ##   ##       ##   ######

################################################################################
################################################################################
################################################################################
################################################################################








##############################################################################################################################################################################################
var new_container

var rot_plus90
var rot_minus90

var midscreen = 0



func render():
	if (weakref(new_container).get_ref()):
		new_container.queue_free()
		
	new_container = $PolyContainer.duplicate()
	add_child(new_container)
	
	midscreen = (Vector2(0,draw_distance).rotated(rotation_angle)).angle()
	
	rot_plus90  = rad_overflow(rotation_angle+(PI/2))
	rot_minus90 = rad_overflow(rotation_angle-(PI/2))
	
	for n in array_walls.size():
		var new_poly = $PolyContainer/Poly0.duplicate()
		
		var array_polygon = []
		var outtasight = 0
		var min_distance = INF
		var array_shading = []
		
		for m in array_walls[n].points.size():
			var rot_object   = rad_overflow((array_walls[n].points[m]-position).angle()-PI/2)
			
			
			#stretching fix conditions
			if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object < rot_minus90 or rot_object > rot_plus90))   or   (rot_object < rot_minus90 && rot_object > rot_plus90):
				var rot_object_plus  = rad_overflow((array_walls[n].points[ (m+1) % array_walls[n].points.size() ]-position).angle()-PI/2)
				var rot_object_minus = rad_overflow((array_walls[n].points[ (m-1) % array_walls[n].points.size() ]-position).angle()-PI/2)
				var neighbours_pm = Vector2(0,0) #pm = "plus, minus"
				
				
				if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object_plus < rot_minus90 or rot_object_plus > rot_plus90))   or   (rot_object_plus < rot_minus90 && rot_object_plus > rot_plus90):
					neighbours_pm.x = 1
				
				if (rotation_angle > PI/2 && rotation_angle < 3*PI/2 && (rot_object_minus < rot_minus90 or rot_object_minus > rot_plus90))   or   (rot_object_minus < rot_minus90 && rot_object_minus > rot_plus90):
					neighbours_pm.y = 1
				
				
				if (neighbours_pm.x == 1) && (neighbours_pm.y == 1):  #both neighbours bad, delete
					pass#continue#passd
				
				
				
				else:
					var limitPlus  = position+(Vector2(0,100).rotated(rotation_angle+PI/2))
					var limitMinus = position+(Vector2(0,100).rotated(rotation_angle-PI/2))
					var point1 = array_walls[n].points[m]
					var point2
					var height1 = array_walls[n].heights[m] + array_walls[n].extraZ[m]
					var height2
					
					
					if (neighbours_pm.x == 0) && (neighbours_pm.y == 1):#minus neighbour bad, go with plus neighbour
						point2 = array_walls[n].points[ (m+1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m+1) % array_walls[n].heights.size() ] + array_walls[n].extraZ[ (m+1) % array_walls[n].heights.size() ]
					
					else:#plus/both neighbour bad, go with minus neighbour
						point2 = array_walls[n].points[ (m-1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m-1) % array_walls[n].heights.size() ] + array_walls[n].extraZ[ (m-1) % array_walls[n].heights.size() ]
						
					
					
					var new_position = new_position(point1, point2, limitPlus, limitMinus, (point1.x - point2.x)*(limitPlus.y - limitMinus.y) - (point1.y - point2.y)*(limitPlus.x - limitMinus.x))  +  Vector2(0,1).rotated(rotation_angle)
					#func new_position(point1,point2,height1,height2,limitPlus,limitMinus,det):
					var xkusu = (new_position-position).angle() - midscreen
					#var lineH = (OS.window_size.y / not_zero(sqrt(pow((new_position.x - position.x), 2) + pow((new_position.y - position.y), 2))))   /  cos(xkusu) #Logic from other raycasters
					var lineH = (OS.window_size.y / not_zero( (new_position - position).length()) )   /  cos(xkusu) #Logic from other raycasters
					
					var C = 1
					if !shading:
						if array_walls[n].darkness != 0:
							C = float(1)/array_walls[n].darkness
						else:
							C = 1
					#else: C = -(    sqrt(pow((new_position.x - position.x), 2) + pow((new_position.y - position.y), 2) + pow(((array_walls[n].heights[m]+array_walls[n].extraZ[m]) - positionZ), 2))    *(float(1*array_walls[n].darkness)/draw_distance)-1)
					else: C = -(    (Vector3(new_position.x, new_position.y, array_walls[n].heights[m]+array_walls[n].extraZ[m]) - Vector3(position.x, position.y, positionZ)).length()    *(float(1*array_walls[n].darkness)/draw_distance)-1)
					
					
					if height1 == height2:#No diagonals, we're done
						array_polygon.append(Vector2(tan(xkusu), ((positionZ+head_height)*lineH)-lineH*(array_walls[n].heights[m]+array_walls[n].extraZ[m]))) #OVER
						
					else:#Need to make diagonal clipping
						#var new_height = (sqrt(pow((point2.x - new_position.x), 2) + pow((point2.y - new_position.y), 2))/sqrt(pow((point2.x - point1.x), 2) + pow((point2.y - point1.y), 2)))*(height1-height2)
						var new_height = ((point2 - new_position).length()/(point2 - point1).length()*(height1-height2))
						
						if (height2 > height1)  or  (height2 < height1): #dont know
							new_height += height2
						
						
						array_polygon.append(Vector2(tan(xkusu), ((positionZ+head_height)*lineH)-lineH*new_height)) #OVER
					
					array_shading.append(Color(C,C,C))
					
					if neighbours_pm.x == neighbours_pm.y:#both good neighbours (1 vertex clipping, need extra point)
						point2 = array_walls[n].points[ (m+1) % array_walls[n].points.size() ]
						height2 = array_walls[n].heights[ (m+1) % array_walls[n].heights.size() ] + array_walls[n].extraZ[ (m+1) % array_walls[n].heights.size() ]
						
						new_position = new_position(point1,point2,limitPlus,limitMinus,(point1.x - point2.x)*(limitPlus.y - limitMinus.y) - (point1.y - point2.y)*(limitPlus.x - limitMinus.x))  +  Vector2(0,1).rotated(rotation_angle)
						
						xkusu = (new_position-position).angle() - midscreen
						#lineH = (OS.window_size.y / not_zero(sqrt(pow((new_position.x - position.x), 2) + pow((new_position.y - position.y), 2))))   /  cos(xkusu) #Logic from other raycasters
						lineH = (OS.window_size.y / not_zero( (new_position - position).length()) )   /  cos(xkusu) #Logic from other raycasters
						
						#if shading: C = -(    sqrt(pow((new_position.x - position.x), 2) + pow((new_position.y - position.y), 2) + pow(((array_walls[n].heights[m]+array_walls[n].extraZ[m]) - positionZ), 2))    *(float(1*array_walls[n].darkness)/draw_distance)-1)
						if shading: C = -(    (Vector3(new_position.x, new_position.y, array_walls[n].heights[m]+array_walls[n].extraZ[m]) - Vector3(position.x, position.y, positionZ)).length()    *(float(1*array_walls[n].darkness)/draw_distance)-1)
						
						if height1 == height2:#No diagonals
							array_polygon.append(Vector2(tan(xkusu), ((positionZ+head_height)*lineH)-lineH*(array_walls[n].heights[m]+array_walls[n].extraZ[m]))) #OVER
						
						else:#diagonal
							#var new_height = (sqrt(pow((point2.x - new_position.x), 2) + pow((point2.y - new_position.y), 2))/sqrt(pow((point2.x - point1.x), 2) + pow((point2.y - point1.y), 2)))*(height1-height2)
							var new_height = ((point2 - new_position).length()/(point2 - point1).length()*(height1-height2))
							
							if height2 > height1: #dont know
								new_height += height2
							elif (height2 < height1) or (new_height > height1):# why, OK
								#if new_height < height2:
								new_height += height2
							
							array_polygon.append(Vector2(tan(xkusu), ((positionZ+head_height)*lineH)-lineH*new_height)) #OVER
						
						array_shading.append(Color(C,C,C))
			
			
			else:#all vertices in front of camera
				#shading = true
				var xkusu = (array_walls[n].points[m]-position).angle() - midscreen
				#var lineH = (OS.window_size.y / not_zero(sqrt(pow((array_walls[n].points[m].x - position.x), 2) + pow((array_walls[n].points[m].y - position.y), 2))))   /  cos(xkusu)
				var lineH = (OS.window_size.y / not_zero( (array_walls[n].points[m] - position).length()) )   /  cos(xkusu) #Logic from other raycasters
				
				array_polygon.append(Vector2(tan(xkusu),((positionZ+head_height)*lineH)-lineH*(array_walls[n].heights[m]+array_walls[n].extraZ[m]))) #OVER
				var C
				if !shading:
					if array_walls[n].darkness != 0:
						C = float(1)/array_walls[n].darkness
					else:
						C = 1
				#else: C = -(    sqrt(pow((array_walls[n].points[m].x - position.x), 2) + pow((array_walls[n].points[m].y - position.y), 2) + pow(((array_walls[n].heights[m]+array_walls[n].extraZ[m]) - positionZ), 2))    *(float(1*array_walls[n].darkness)/draw_distance)-1)
				else: C = -(    (Vector3(array_walls[n].points[m].x, array_walls[n].points[m].y, array_walls[n].heights[m]+array_walls[n].extraZ[m]) - Vector3(position.x, position.y, positionZ)).length()    *(float(1*array_walls[n].darkness)/draw_distance)-1)
				array_shading.append(Color(C,C,C))
			
			if cull_on && array_polygon.size() > 0:
				if abs(array_polygon[array_polygon.size()-1].y*$PolyContainer.scale.y+(OS.window_size.y*lookingZ)) > OS.window_size.y/2:
					outtasight += sign(array_polygon[array_polygon.size()-1].y*$PolyContainer.scale.y+(OS.window_size.y*lookingZ))
					
			
			
			
			
			
			
			
			
			
			
			
			
			
			#var distance = sqrt(pow((array_walls[n].points[m].x - position.x), 2) + pow((array_walls[n].points[m].y - position.y), 2) + pow(((array_walls[n].heights[m]+array_walls[n].extraZ[m]) - positionZ), 2))
			var distance = (Vector3(array_walls[n].points[m].x, array_walls[n].points[m].y, array_walls[n].heights[m]+array_walls[n].extraZ[m]) - Vector3(position.x, position.y, positionZ)).length()
			
			
			if -(distance*(float(8192)/draw_distance)-4096) < min_distance:
				min_distance = -(distance*(float(8192)/draw_distance)-4096)
			
			if m == array_walls[n].points.size()-1:#Last cycle, time to end things
				if array_walls[n].onesided != 0:
					if sign(array_walls[n].onesided) == 1:
						if Geometry.is_polygon_clockwise(array_polygon):
							new_poly.queue_free()
							break
					elif sign(array_walls[n].onesided) == -1:
						if !Geometry.is_polygon_clockwise(array_polygon):
							new_poly.queue_free()
							break
				
				
				
				
				
				if cull_on && (abs(outtasight) > array_polygon.size()-1):
					new_poly.queue_free()
					break
					
				
				
				
				if abs(min_distance) > 4096:
					new_poly.modulate = Color(0,0,0)
					new_poly.modulate.a8 = array_walls[n].modulate.a8/2
					new_poly.z_index = -4095
				else:
					new_poly.z_index = min_distance
					
				new_poly.modulate = array_walls[n].modulate
				
				if !textures_on && array_walls[n].textures_on && (array_walls[n].texture_path == "res://textures/chainfence.png" or array_walls[n].texture_path == "res://textures/chainfence2.png" or array_walls[n].texture_path == "res://textures/stretchtest.png"):
					new_poly.modulate.a8 /= 2
				
				
				
				if (textures_on or array_walls[n].texture_path == "res://textures/wheelEGA64.png") && array_walls[n].textures_on && (array_walls[n].texture_path != "res://textures/solid1.png"): #Texture mapping
					new_poly.texture = load(array_walls[n].texture_path)
					new_poly.texture_rotation_degrees = array_walls[n].texture_rotate
					#new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()
					if array_walls[n].UV_textures:
						var howmany = array_polygon.size() #m+1
						
						
						if  howmany == 3:
							new_poly.texture_offset = Vector2(0,0) + array_walls[n].texture_offset
							new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()
							new_poly.uv = [Vector2(0,0), Vector2(1,1), Vector2(0,1)]
						elif howmany == 4:
							new_poly.texture_offset = Vector2(0,0) + array_walls[n].texture_offset
							new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()
							new_poly.uv = [Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]
						elif howmany == 5:
							new_poly.texture_offset = Vector2(0,1) + array_walls[n].texture_offset
							new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/2
							new_poly.uv = [Vector2(2,4), Vector2(3,3), Vector2(4,4), Vector2(4,5), Vector2(2,5)]
						elif howmany == 6:
							new_poly.texture_offset = Vector2(1,2) + array_walls[n].texture_offset
							new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/4
							new_poly.uv = [Vector2(-1,3), Vector2(1,2), Vector2(3,3), Vector2(3,5), Vector2(1,6), Vector2(-1,5)]
						elif howmany == 7:
							new_poly.texture_offset = Vector2(1,0) + array_walls[n].texture_offset
							new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/4
							new_poly.uv = [Vector2(4,1), Vector2(5,0), Vector2(6,1), Vector2(7,3), Vector2(6,4), Vector2(4,4), Vector2(3,3)]
						elif howmany == 8:
							new_poly.texture_offset = Vector2(0,0) + array_walls[n].texture_offset
							new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/6
							new_poly.uv = [Vector2(1,1), Vector2(3,0), Vector2(5,1), Vector2(6,3), Vector2(5,5), Vector2(3,6), Vector2(1,5), Vector2(0,3)]
						elif  howmany == 9:
							new_poly.texture_offset = Vector2(1,-2) + array_walls[n].texture_offset
							new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/6
							new_poly.uv = [Vector2(0,3), Vector2(2,2), Vector2(4,3), Vector2(5,5), Vector2(4,7), Vector2(3,8), Vector2(1,8), Vector2(0,7), Vector2(-1,5)]
						elif howmany == 10:
							new_poly.texture_offset = Vector2(0,-1) + array_walls[n].texture_offset
							new_poly.texture_scale = array_walls[n].texture_repeat*new_poly.texture.get_size()/6
							new_poly.uv = [Vector2(1,2), Vector2(2,1), Vector2(4,1), Vector2(5,2), Vector2(6,4), Vector2(5,6), Vector2(4,7), Vector2(2,7), Vector2(1,6), Vector2(0,4)]
							
					else:
						new_poly.texture_scale = $PolyContainer.scale * float(1)/array_walls[n].texture_repeat
						
						
		#end of M loop, back to N
		
		
		new_poly.vertex_colors = array_shading
		new_poly.polygon = array_polygon
		new_container.add_child(new_poly) #Over!!!!
		
	
	if (weakref(new_container).get_ref()):
		for o in array_sprites.size():
			var new_sprite = $PolyContainer/Sprite0.duplicate()
			
			var xkusu = (array_sprites[o].position - position).angle() - midscreen
			#var lineH = (OS.window_size.y /  not_zero(sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2)))) / cos(xkusu) 
			var lineH = (OS.window_size.y / not_zero( (array_sprites[o].position - position).length()) )   /  cos(xkusu) #Logic from other raycasters
			
			#new_sprite.scale = Vector2( ((((OS.window_size.x /  not_zero(sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2)))) / cos(xkusu) )/$PolyContainer.scale.x) * 0.145) * array_sprites[o].scale_extra.x ,
			#new_sprite.scale = Vector2( ((((OS.window_size.x /  not_zero(sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2)))) / cos(xkusu) )/$PolyContainer.scale.x) * 0.145) * array_sprites[o].scale_extra.x ,
			#new_sprite.scale = Vector2( ((((OS.window_size.x /  not_zero(sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2)))) / cos(xkusu) )/$PolyContainer.scale.x) * (180-angles)/1000) * array_sprites[o].scale_extra.x *4,
			new_sprite.scale = Vector2( ((((OS.window_size.x /  not_zero((array_sprites[o].position - position).length())) / cos(xkusu) )/$PolyContainer.scale.x) * (180-angles)/1000) * array_sprites[o].scale_extra.x *4,
			lineH * array_sprites[o].scale_extra.y)
			
			
			if sign(array_sprites[o].scale_extra.x) != sign(new_sprite.scale.x):
				continue
			
			if( (array_sprites[o].dontScale == -1) && ((new_sprite.scale.x < array_sprites[o].scale_extra.x/$PolyContainer.scale.x) or (new_sprite.scale.y < array_sprites[o].scale_extra.y/$PolyContainer.scale.y))) or ((array_sprites[o].dontScale == 1) && ((new_sprite.scale.x > array_sprites[o].scale_extra.x/$PolyContainer.scale.x) or (new_sprite.scale.y > array_sprites[o].scale_extra.y/$PolyContainer.scale.y))) or (array_sprites[o].dontScale == 2):
				new_sprite.scale = array_sprites[o].scale_extra/$PolyContainer.scale
			
			new_sprite.position = Vector2(tan(xkusu), ((positionZ)*lineH)-lineH*(array_sprites[o].positionZ-head_height+array_sprites[o].spr_height) )
			
			new_sprite.texture = array_sprites[o].texture
			
			#if cull_on && (abs(new_sprite.position.y*$PolyContainer.scale.y+(OS.window_size.y*lookingZ)) > OS.window_size.y/2):
			#	continue
			
			
			new_sprite.vframes = array_sprites[o].vframes
			new_sprite.hframes = array_sprites[o].hframes
			if !array_sprites[o].dontScale:
				new_sprite.offset.y = -new_sprite.texture.get_height()/10
			
			
			
			if !array_sprites[o].dontZ:#lets re-use xkusu
				#xkusu = sqrt(pow((array_sprites[o].position.x - position.x), 2) + pow((array_sprites[o].position.y - position.y), 2) + pow((array_sprites[o].positionZ - positionZ), 2))
				xkusu = (Vector3(array_sprites[o].position.x, array_sprites[o].position.y, array_sprites[o].positionZ) - Vector3(position.x, position.y, positionZ)).length()
				if abs(-(xkusu*(float(8192)/draw_distance)-4096)) > 4096:
					#break
					new_sprite.modulate = Color(0,0,0)
					new_sprite.modulate.a8 = array_sprites[o].modulate.a8/2
					new_sprite.z_index = -4095
					
				else:
					var C
					if shading: C =  -(xkusu*(float(1*array_sprites[o].darkness)/draw_distance)-1)
					elif array_sprites[o].darkness > 0: C = float(1)/array_sprites[o].darkness
					else: C = float(1)*-array_sprites[o].darkness
					new_sprite.modulate = array_sprites[o].modulate*C
					new_sprite.modulate.a8 = array_sprites[o].modulate.a8
					new_sprite.z_index = -(xkusu*(float(8192)/draw_distance)-4096)
					
			else:
				new_sprite.z_index = 4096
			
			
			if array_sprites[o].rotations > 1:
				var frame_rot = 0
				var angletester
				
				
				angletester = int(deg_overflow(rad_deg(rotation_angle) - array_sprites[o].rotation_degrees)+180) % 360
				
				
				for n in array_sprites[o].rotations:
					if (angletester < (360/(array_sprites[o].rotations+1))*n) or (angletester > 360-((360/(array_sprites[o].rotations+1))*n)):
						frame_rot = (n*new_sprite.hframes) - new_sprite.hframes
						if frame_rot < 0:
							frame_rot = 0
						
						if range(array_sprites[o].vframes*array_sprites[o].hframes).has(array_sprites[o].anim + frame_rot):
							new_sprite.frame = (array_sprites[o].anim + frame_rot) % (array_sprites[o].vframes*10)
							break
				
				
				if angletester > 180:
					new_sprite.flip_h = true
				
				
				
			else:
				new_sprite.frame = array_sprites[o].anim
			
			
			
			
			
			new_container.add_child(new_sprite)
			
			if sprite_shadows && array_sprites[o].shadow:## && (array_sprites[o].positionZ > positionZ-head_height):# && (new_sprite.position.y+(new_sprite.texture.get_size().y*new_sprite.scale.y)/2 > 0):
				#if new_sprite.position.y - (new_sprite.offset.y*new_sprite.scale.y) > 0:
				#if ((new_sprite.position.y - new_sprite.offset.y)*new_sprite.scale.y)*new_container.scale.y > 0:
					var shadow = new_sprite.duplicate()
					
					shadow.z_index = new_sprite.z_index-1
					if !array_sprites[o].reflect:
						shadow.position.y = ((positionZ)*lineH)-lineH*(array_sprites[o].shadowZ-head_height+array_sprites[o].shadow_height )# - array_sprites[o].positionZ-array_sprites[o].shadow_height
						shadow.modulate = Color(0,0,0)
						shadow.modulate.a8 = new_sprite.modulate.a8/2 - abs(array_sprites[o].positionZ-array_sprites[o].shadowZ)/10
						shadow.scale.y *= 0.125
						shadow.scale.x *= 1.2
						#shadow.scale.x *= sin(rotation_angle)
						#shadow.rotation_degrees = sin(rotation_angle)
					else:
						shadow.position.y = ((positionZ)*lineH)-lineH*(array_sprites[o].shadowZ-head_height+array_sprites[o].reflect_height)# + array_sprites[o].positionZ-array_sprites[o].shadow
						shadow.modulate.a8 = new_sprite.modulate.a8/1.5 - array_sprites[o].positionZ-array_sprites[o].shadowZ
						shadow.scale.y *= -0.25
						shadow.scale.x *= 0.7
					
					if shadow.position.y < 0:
						shadow.queue_free()
					
					new_container.add_child(shadow)
				
			




func new_position(point1,point2,limitPlus,limitMinus,det):
	var new_position
	
	if det != 0:
		new_position = Vector2(
		((point1.x*point2.y - point1.y*point2.x) * (limitPlus.x-limitMinus.x)  -  (point1.x-point2.x) * (limitPlus.x*limitMinus.y - limitPlus.y*limitMinus.x))/det,
		((point1.x*point2.y - point1.y*point2.x) * (limitPlus.y-limitMinus.y)  -  (point1.y-point2.y) * (limitPlus.x*limitMinus.y - limitPlus.y*limitMinus.x))/det)
	else:
		new_position = Vector2(0,0)
	
	return(new_position)



















var array_walls = []
var array_sprites = []

func _on_ViewArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("render") && (higfx or ((higfx) == (body.is_in_group("higfx")))):
		if !array_walls.has(body):
			array_walls.push_back(body)
	
	elif body.is_in_group("rendersprite") && (higfx or ((higfx) == (body.is_in_group("higfx")))):
		if !array_sprites.has(body):
			array_sprites.push_back(body)
	

func _on_ViewArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("render"):
		if array_walls.has(body):
			array_walls.erase(body)
	
	elif body.is_in_group("rendersprite"):
		if array_sprites.has(body):
			array_sprites.erase(body)
	
	if array_walls.size() == 0 && array_sprites.size() == 0 && (weakref(new_container).get_ref()):
		new_container.queue_free()


########        ########            ####        ####            ####  
########        ########            ####        ####            ####
####    ####    ####    ####    ####    ####    ####    ####    ####  
####    ####    ####    ####    ####    ####    ####    ####    ####  
####    ####    ########        ############    ####    ####    ####  
####    ####    ########        ############    ####    ####    ####  
########        ####    ####    ####    ####        ####    ####    
########        ####    ####    ####    ####        ####    ####      

################################################################################
################################################################################
################################################################################
################################################################################














##############################################################################################################################################################################################


func _draw():
	if Input.is_action_pressed("bug_closeeyes"):
		if abs(map_draw) > 3:
			print(">M I S T A K E: map_draw value invalid!")
			map_draw = 3*sign(map_draw)
		
		if Worldconfig.zoom < 1:
			draw_line(Vector2(-get_viewport().size.x/2, -get_viewport().size.y/2), Vector2(get_viewport().size.x/2, -get_viewport().size.y/2), Color(1,0,0), 1)
			draw_line(Vector2(-get_viewport().size.x/2, get_viewport().size.y/2), Vector2(get_viewport().size.x/2, get_viewport().size.y/2), Color(1,0,0), 1)
			draw_line(Vector2(-get_viewport().size.x/2, get_viewport().size.y/2), Vector2(-get_viewport().size.x/2, -get_viewport().size.y/2), Color(1,0,0), 1)
			draw_line(Vector2(get_viewport().size.x/2, get_viewport().size.y/2), Vector2(abs(get_viewport().size.x)/2, -get_viewport().size.y/2), Color(1,0,0), 1)
		
		
		#if Input.is_action_pressed("bug_closeeyes"): #Must always update otherwise it doesn't dissapear
		var shine = Color((randi() % 2),(randi() % 2),(randi() % 2))
		
		
		if sign(map_draw) == 1:
			draw_line(Vector2(0,0), Vector2(0,draw_distance).rotated(rotation_angle), Color(1,1,1), 1)
			
			draw_line(Vector2(0,0), Vector2(0,draw_distance*2).rotated(rotation_angle-deg_rad(angles/2)), shine, 1)
			draw_line(Vector2(0,0), Vector2(0,draw_distance*2).rotated(rotation_angle+deg_rad(angles/2)), shine, 1)
			draw_line(Vector2(0,draw_distance*2).rotated(rotation_angle-deg_rad(angles/2)), Vector2(0,draw_distance*2).rotated(rotation_angle+deg_rad(angles/2)), shine, 1)
			
			draw_line(Vector2(0,9999).rotated(rotation_angle+PI/2), Vector2(0,9999).rotated(rotation_angle-PI/2), Color(0.5, 0, 1), 1)
		
		else:
			draw_line(Vector2(0,0), Vector2(0,draw_distance).rotated(rotation_angle), shine, 1)
		
		
		
		
		
		
		
		
		
		
		
		var targets_in_scene = get_tree().get_nodes_in_group("render")
		
		
		if targets_in_scene.size() != 0: #If anyone at all
			if abs(map_draw) == 1: #all walls
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
					
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								var zoomies = 1
								
								if m < targets_in_scene[n].points.size()-1:
									draw_line((targets_in_scene[n].points[m]-position)*zoomies, (targets_in_scene[n].points[m+1]-position)*zoomies, targets_in_scene[n].modulate, 1)
								else:
									draw_line((targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position)*zoomies, (targets_in_scene[n].points[0]-position)*zoomies, targets_in_scene[n].modulate, 1)
									
						
						targets_in_scene = [] #reset
			
			
			elif abs(map_draw) == 2: #all 3D walls
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
						
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line(((targets_in_scene[n].heights[ m                                 ]+1) / not_zero(lookingZ)/1000) * (targets_in_scene[n].points[ m                                 ]-position),  ((targets_in_scene[n].heights[m+1]+1) / not_zero(lookingZ)/1000)*(targets_in_scene[n].points[m+1]-position), targets_in_scene[n].modulate, 1)
									
								else:
									draw_line(((targets_in_scene[n].heights[targets_in_scene[n].points.size()-1]+1) / not_zero(lookingZ)/1000) * (targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position),  ((targets_in_scene[n].heights[ 0 ]+1) / not_zero(lookingZ)/1000)*(targets_in_scene[n].points[ 0 ]-position), targets_in_scene[n].modulate, 1)
									
						
						targets_in_scene = [] #reset
			
			
			elif abs(map_draw) == 3: #all 3D walls 2
				for item in targets_in_scene:
					if (weakref(item).get_ref()): #If they are, then
						
						
						
						for n in targets_in_scene.size():
							for m in targets_in_scene[n].points.size():
								if m < targets_in_scene[n].points.size()-1:
									draw_line((1+targets_in_scene[n].heights[ m                                 ] * lookingZ/1000) * (targets_in_scene[n].points[ m                                 ]-position),  (1+targets_in_scene[n].heights[m+1] * lookingZ/1000)*(targets_in_scene[n].points[m+1]-position), targets_in_scene[n].modulate, 1)
									
								else:
									draw_line((1+targets_in_scene[n].heights[targets_in_scene[n].points.size()-1] * lookingZ/1000) * (targets_in_scene[n].points[targets_in_scene[n].points.size()-1]-position),  (1+targets_in_scene[n].heights[ 0 ] * lookingZ/1000)*(targets_in_scene[n].points[ 0 ]-position), targets_in_scene[n].modulate, 1)
									
						
						targets_in_scene = [] #reset


	####    ####                ####            ############
####    ####    ####        ####    ####        ####        ####
####    ####    ####        ####    ####        ####        ####
####            ####        ############        ############
####            ####        ####    ####        ####
####            ####        ####    ####        ####

################################################################################
################################################################################
################################################################################
################################################################################






func rad_deg(N):
	N *= 180/PI
	return N

func deg_rad(N):
	N *= PI/180
	return N


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


func array_multiply(array, mult):
	for n in array.size():
		array[n] = array[n]*mult
	
	return array

func array_divide(array, div):
	for n in array.size():
		array[n] = array[n]/div
	
	return array


func array_looping(to_check, array_size):
	if to_check < 0:
		to_check += array_size
	
	if to_check > array_size-1:
		to_check -= array_size
	
	
	if (to_check < 0) or (to_check > array_size-1):
		to_check = array_looping(to_check, array_size)
	
	return(to_check)

func not_zero(n):
	if n == 0:
		return 1
	else:
		return n



func overflow(N, minn, maxx):
	while N > maxx:
		N -= range(minn, maxx).size()
	
	while N < minn:
		N += range(minn, maxx).size()
	
	return N
