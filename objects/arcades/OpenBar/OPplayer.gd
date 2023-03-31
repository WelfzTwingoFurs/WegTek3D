extends KinematicBody2D

var motion = Vector2()
var input = Vector2()

var ladder = null
var ladderbusy = false

var dead
var jumpsfx = true

func _physics_process(_delta):
	#move_and_slide(linear_velocity: Vector3, up_direction: Vector3 = Vector3( 0, 0, 0 ), stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true)
	motion = move_and_slide(motion,Vector2(0,-1),true)
	
	if motion.length() && !dead:
		if is_on_floor():
			get_parent().get_parent().score += 0.01 * (get_parent().get_parent().barrelshand+1)
		else:
			get_parent().get_parent().score += 0.02 * (get_parent().get_parent().barrelshand+1)
	
	if !ladderbusy:
		if input.y == -1:
			motion.y += 3.25
		elif input.y == 1:
			motion.y += 11
			motion.x -= sign(motion.x)
		else:
			motion.y += 3.75
		
		if is_on_floor():
			motion.x = (50-(6*get_parent().get_parent().barrelshand))*input.x
		
	else:
		motion.y = input.y*25
		


var was_on_floor = false
var spr_offset = 0
var lastposY = -INF

func _ready():
	$Sprite.rotation_degrees = 0
	$Sprite.offset = Vector2(-8,-16)

onready var falldist = position.y

func _process(_delta):
	if dead:
		$AniPlay.play("die")
		$AniPlay.playback_speed = 1
		if position.y > lastposY+8:
			$Col.disabled = false
			$Col2.disabled = false
		if is_on_floor():
			get_parent().get_parent().audio_noise.sfx_ouch()
			$Col.disabled = true
			$Col2.disabled = true
			lastposY = position.y
			motion.y = -10 + randi()%5
			motion.x =  -100 + randi()%200
		if is_on_wall():
			motion.x *= -1
	
	else:
		if (falldist - position.y) < -25:
			get_parent().get_parent().outdoor.frame = 6
			dead = true
		
		if get_parent().get_parent().barrelshand != 0: spr_offset = 20
		else: spr_offset = 0
		
		$Sprite2.frame = get_parent().get_parent().barrelshand
		
		
		if Input.is_action_pressed("ply_left"):
			input.x = -1
		elif Input.is_action_pressed("ply_right"):
			input.x = 1
		else:
			input.x = 0
		
		if Input.is_action_pressed("ply_up"):
			input.y = -1
		elif Input.is_action_pressed("ply_down"):
			input.y = 1
		else:
			input.y = 0
		
		if !ladderbusy:
			set_collision_mask_bit(19,true)
			if is_on_floor():
				falldist = position.y
				if was_on_floor != is_on_floor():
					jumped = false
					was_on_floor = is_on_floor()
				
				$Col.disabled = false
				
				if motion.x != 0: $AniPlay.playback_speed = 1
				else: $AniPlay.playback_speed = 0
				
				
				if ($Sprite.frame - spr_offset) == 3: $Sprite.frame = 4 + spr_offset
				
				if input.x != 0:
					if get_parent().get_parent().barrelshand < 1: $AniPlay.play("walk")
					else: $AniPlay.play("walkcarry")
					$Sprite.flip_h = input_to_flip(input.x)
					$Sprite2.flip_h = input_to_flip(input.x)
					$Sprite2.offset.x = -sign($Sprite2.offset.x)*input.x
				else:
					if !jumped: if motion.y < 0: motion.y = 0
				
				
				
				if Input.is_action_just_pressed("ply_jump"):
					jumped = true
					if jumpsfx: get_parent().get_parent().audio_square1.sfx_jump(position.y)
					motion.y = -100
					
				
				if $Sprite2.position.y != -32: $Sprite2.position.y = lerp($Sprite2.position.y,-32,0.01)
				
			
			else:
				if motion.y > 0: $Sprite2.position.y = -32 - (motion.y/10)
				else: $Sprite2.position.y = -32
				
				was_on_floor = is_on_floor()
				if is_on_wall(): motion.x *= -1
				
				if !jumped:
					if motion.y < 0: motion.y = 1
					else: motion.y += 1
					if Input.is_action_just_pressed("ply_jump"):
						jumped = true
						get_parent().get_parent().audio_square1.sfx_jump(position.y)
						motion.y = -100
				
				$Col.disabled = true
				$AniPlay.stop()
				if get_parent().get_parent().barrelshand < 1:
					if motion.x != 0: $Sprite.frame = 3
					elif (motion.y > 1) && ($Sprite.frame != 3): $Sprite.frame = 5
					elif ($Sprite.frame != 3): $Sprite.frame = 6 
				else:
					$Sprite.frame = 23
			
			
			if (ladder != null): if ((input.y == 1) && (ladder.position.y > position.y)) or ((input.y == -1) && (ladder.position.y < position.y)): ladderbusy = true
			
		elif ladder != null:
			falldist = position.y
			set_collision_mask_bit(19,false)
			motion.x = 0
			
			position.x = ladder.position.x
			
			
			if input.y != 0:
				$AniPlay.play("climb")
				$AniPlay.playback_speed = 1
			else:
				$AniPlay.playback_speed = 0
				if input.x:
					$Sprite.flip_h = input_to_flip(input.x)
					$Sprite.frame = 9
				else:
					$Sprite.frame = 5
			
			if Input.is_action_just_pressed("ply_jump"):
				$AniPlay.stop()
				get_parent().get_parent().audio_square1.sfx_jump(position.y)
				$Sprite.flip_h = input_to_flip(input.x)
				jumped = true
				motion.y = -100
				motion.x = 50*input.x
				ladderbusy = false
			
			
			
		elif ladder == null:
			falldist = position.y
			ladderbusy = false
	
	
	


var jumped = false


func input_to_flip(x):
	if x == 1: x = false
	elif x == -1: x = true
	return x

func flip_to_input(x):
	if !x: x = 1
	elif x: x = -1
	return x
