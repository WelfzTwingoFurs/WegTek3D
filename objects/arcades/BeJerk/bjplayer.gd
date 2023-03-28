extends KinematicBody2D

var motion = Vector2()
var input = Vector2()
var bullet = preload("res://objects/arcades/BeJerk/bjbullet.tscn")

func _ready():
	get_parent().player = self
	$Sprite.frame = 8

func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))

var drive = null

export var weapon = 0

func _process(_delta):
	if get_parent().get_parent().game_on:
		if Input.is_action_pressed("ply_up"):
			input.y = -1
		elif Input.is_action_pressed("ply_down"):
			input.y = 1
		else:
			input.y = 0
		
		if Input.is_action_pressed("ply_right"):
			input.x = 1
		elif Input.is_action_pressed("ply_left"):
			input.x = -1
		else:
			input.x = 0
	
	
	
	if drive != null:
		$Sprite.visible = false
		$AniPlay.stop()
		$Col.disabled = true
		position = drive.position
		if Input.is_action_just_pressed("ply_jump"):
			drive = null
		
	else:
		$Sprite.visible = true
		$Col.disabled = false
		
		if input.x != 0: $Sprite.flip_h = input.x -1
		
		if Input.is_action_just_pressed("ply_jump") && cars.size() == 0:
			var bullet2 = bullet.instance()
			bullet2.type = weapon
			
			get_parent().get_parent().ammo -= 1
			if (get_parent().get_parent().ammo < 1) && (weapon != 1): weapon = -1
			
			if input != Vector2():
				bullet2.input = input
				bullet2.position = position + (input*8)
			else:
				if ($Sprite.frame == 0) or ($Sprite.frame == 4) or ($Sprite.frame == 16):
					bullet2.input.x = flip_to_input($Sprite.flip_h)
				elif $Sprite.frame == 8:
					bullet2.input.y = 1
				elif $Sprite.frame == 12:
					bullet2.input.y = -1
				
				if $Sprite.frame == 4:
					bullet2.input.y = 1
				if $Sprite.frame == 16:
					bullet2.input.y = -1
				
				bullet2.position = position + (bullet2.input*10)
				#print(bullet2.input.x,"    ",flip_to_input($Sprite.flip_h))
			
			bullet2.daddy = self
			get_parent().add_child(bullet2)
			
			
		
		elif Input.is_action_pressed("ply_jump"):
			if Input.is_action_just_pressed("ply_jump") && (drive == null):
				if cars.size() != 0:
					var dist = INF
					var thiscar = null
					for n in cars.size():
						if (cars[n].position-position).length() < dist:
							dist = (cars[n].position-position).length()
							thiscar = cars[n]
					drive = thiscar
					thiscar.drive = true
					
			else:
				motion = Vector2()
				$AniPlay.stop()
				if abs(input.x) != abs(input.y):
					if input.x: $Sprite.frame = 20 #side
					elif input.y == 1: $Sprite.frame = 26 #down
					elif input.y == -1: $Sprite.frame = 27 #up
				
				else:
					if input.y == 1: $Sprite.frame =  25 #diagD
					elif input.y == -1: $Sprite.frame =  24 #diagU
					else: # == 0
						if ($Sprite.frame == 0): $Sprite.frame = 20
						elif ($Sprite.frame == 8): $Sprite.frame = 26
						elif ($Sprite.frame == 12): $Sprite.frame = 27
						elif ($Sprite.frame == 16): $Sprite.frame = 24
						elif ($Sprite.frame == 4): $Sprite.frame = 25
			
			
		
		else:#######################################################################
			motion = input*75
			if input == Vector2(0,0):
				$AniPlay.playback_speed = 0
				if ($AniPlay.current_animation == "walkSide") or ($Sprite.frame == 20): $Sprite.frame = 0
				elif ($AniPlay.current_animation == "walkDown") or ($Sprite.frame == 26): $Sprite.frame = 8
				elif $AniPlay.current_animation == "walkUp" or ($Sprite.frame == 27): $Sprite.frame = 12
				elif $AniPlay.current_animation == "walkDiagU" or ($Sprite.frame == 24): $Sprite.frame = 16
				elif $AniPlay.current_animation == "walkDiagD" or ($Sprite.frame == 25): $Sprite.frame = 4
				$AniPlay.stop()
				
				
			
			else:
				if OS.get_ticks_msec() % 200 == 0: get_parent().get_parent().score += 1
				
				$AniPlay.playback_speed = 1.1
				if abs(input.x) != abs(input.y):
					if input.x: $AniPlay.play("walkSide")
					elif input.y == 1: $AniPlay.play("walkDown")
					elif input.y == -1: $AniPlay.play("walkUp")
					
					
				
				else:
					if input.y == 1: $AniPlay.play("walkDiagD")
					elif input.y == -1: $AniPlay.play("walkDiagU")
					
					
	
	

func flip_to_input(x):
	if !x: x = 1
	elif x: x = -1
	return x


var cars = []

func _on_Area_body_entered(body):
	if body.is_in_group("bjcar") && !cars.has(body): cars.push_back(body)


func _on_Area_body_exited(body):
	if cars.has(body): cars.erase(body)
