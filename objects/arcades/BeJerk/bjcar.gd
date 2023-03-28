extends KinematicBody2D

var motion = Vector2()
var input = Vector2()
var drive = false
var was_drive = false

func _physics_process(_delta):
	if drive:
		motion = move_and_slide(motion, Vector2(0,-1))
		motion = Vector2(0,speed).rotated(deg2rad(angle))
		if (speed < 1)  or (input.y == 0) or (input.y == sign(speed)):
			speed = lerp(speed,(input.y*max_speed),accel)
		elif input.y != sign(speed):
			#speed = lerp(speed,0,deaccel*get_parent().get_parent().scale.length())
			speed = lerp(speed,0,deaccel)
	else:
		if speed > 0:
			motion = move_and_slide(motion, Vector2(0,-1))
			motion = Vector2(0,speed).rotated(deg2rad(angle))
		speed = lerp(speed,0,accel)

var angle = 0
var speed = 0
export var max_speed = 750
export var accel = 0.003
export var deaccel = 0.15

func _process(_delta):
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		speed /= 2
	
	if dead:
		#modulate.a = 0 if Engine.get_frames_drawn() % 2 == 0 else 1
		$AniPlay.play("die")
	else:
		if (angle == 0) or (angle == 360):
			$Sprite.flip_h = false
			$Sprite.frame = 0
		elif angle == 45:
			$Sprite.flip_h = false
			$Sprite.frame = 1
		elif angle == 90:
			$Sprite.flip_h = false
			$Sprite.frame = 2
		elif angle == 135:
			$Sprite.flip_h = false
			$Sprite.frame = 3
		elif angle == 180:
			$Sprite.flip_h = false
			$Sprite.frame = 4
		elif angle == 225:
			$Sprite.flip_h = true
			$Sprite.frame = 3
		elif angle == 270:
			$Sprite.flip_h = true
			$Sprite.frame = 2
		elif angle == 315:
			$Sprite.flip_h = true
			$Sprite.frame = 1
		
		#print(angle)
		
		if !drive:
			was_drive = false
			input = Vector2()
		else:
			#speed = lerp(speed,(input.y*max_speed)*get_parent().get_parent().scale.length(),0.001*get_parent().get_parent().scale.length())
			#motion = Vector2(0,speed).rotated(deg2rad(angle))
			if was_drive != drive:
				was_drive = drive
			else:
				if Input.is_action_just_pressed("ply_jump"):
					drive = false
			
			if Input.is_action_pressed("ply_up"):
				input.y = -1
			elif Input.is_action_pressed("ply_down"):
				input.y = 1
			else:
				input.y = 0
			
			if int(motion.length()) != 0:
				if Input.is_action_just_pressed("ply_right"):
					angle += 45
					if angle > 360:
						angle = 45
				elif Input.is_action_just_pressed("ply_left"):
					angle -= 45
					if angle < 0:
						angle = 315

var dead = false
var health = 20

func take_damage(dmg):
	position += Vector2(randi() % 2, randi() % 2)
	health -= dmg
	if health <= 0:
		dead = true
		get_parent().get_parent().score += get_parent().get_parent().combo*1000
		get_parent().get_parent().toptimer += 100
		get_parent().get_parent().topstring = str("BOOM!CAR DESTROYED:+",get_parent().get_parent().combo*1000)
		get_parent().get_parent().combo += 1
	else:
		get_parent().get_parent().topstring = str("CAR DAMAGE:+",get_parent().get_parent().combo*100)
		get_parent().get_parent().score += 100
		get_parent().get_parent().combo += 1




func deg_overflow(N):
	if N > 360:
		N -= 360
	elif N < 360:
		N += 360
	
	return N

func rad_overflow(N):
	if N > PI*2:
		N -= PI*2
	elif N < 0:
		N += PI*2
	
	return N

func int_vector(Q):
	Q.x = int(Q.x)
	Q.y = int(Q.y)
	
	return Q


func _on_Area2D_body_entered(body):
	if abs(motion.length()) > 50:
		if body.is_in_group("bjouch"):
			body.take_damage(motion.length()/50)
			if body.has_method("health"):
				body.position += Vector2(randi() % 10,randi() % 10)
				if body.health < (motion.length()/50):
					body.position += Vector2(randi() % 10,randi() % 10)
