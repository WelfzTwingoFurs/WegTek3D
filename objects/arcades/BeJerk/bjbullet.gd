extends KinematicBody2D

var motion = Vector2()
var input = Vector2()
var daddy = null

func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = input*speed

func _process(_delta):
	if input == Vector2(): queue_free()
	
	#modulate.a = 0 if Engine.get_frames_drawn() % 2 == 0 else 1
	
#	if OS.get_ticks_msec() % 9 == 0: modulate = Color(1,0,0)
#	elif OS.get_ticks_msec() % 8 == 0: modulate = Color(0,1,0)
#	elif OS.get_ticks_msec() % 7 == 0: modulate = Color(0,0,1)
#	elif OS.get_ticks_msec() % 6 == 0: modulate = Color(1,1,0)
#	elif OS.get_ticks_msec() % 5 == 0: modulate = Color(1,0,1)
#	elif OS.get_ticks_msec() % 4 == 0: modulate = Color(0,1,1)
#	elif OS.get_ticks_msec() % 3 == 0: modulate = Color(1,1,1)
#	elif OS.get_ticks_msec() % 2 == 0: modulate = Color(0,0,0)
	
	if type == -1:
		$AniPlay.play("punch")
		
	else:
		if input.x != 0: $Sprite.flip_h = input.x -1
		if input.y != 0: $Sprite.flip_v = input.y +1
		
		if abs(input.x) != abs(input.y):
			if input.x:
				if type == 0: $Sprite.frame = 0 #side
				if type == 1: $Sprite.frame = 3 #side
				if type == 2: $Sprite.frame = 12 #side
			elif input.y:
				if type == 0: $Sprite.frame = 1 #down / up
				if type == 1: $Sprite.frame = 4 #down / up
				if type == 2: $Sprite.frame = 13 #down / up
		
		elif input.y:
			if type == 0: $Sprite.frame =  2 #diagD / diagU
			if type == 1: $Sprite.frame =  5 #diagD / diagU
			if type == 2: $Sprite.frame =  14 #diagD / diagU
		
		
		if (position - spawnpos).length() > ranger:
			queue_free()
		
		#if (type == 3) && ((position - spawnpos).length() > ranger/2) && (speed > 0):
		#	speed *= -1
	
	
	
	if type == 1:
		if Input.is_action_just_released("ply_jump"): queue_free()
		
		if daddy.input != Vector2():
			input = daddy.input
			position = daddy.position + (input*11)

var extra_position

var spawnpos = Vector2()
var type = 0
var speed = 1000
var ranger = 10
var damage = 5

func _ready():
	spawnpos = position
	if type == 0: # gands
		speed = 333
		ranger = INF
		damage = 5
	elif type == 1: # 'noife dagger
		speed = 0
		ranger = 100
		damage = 8
		for n in get_tree().get_nodes_in_group("bjbullet"): if n != self: n.queue_free() #only 1 shot at a time
		set_collision_mask_bit(19,false)
	elif type == 2: # bö
		speed = 166
		ranger = 75
		damage = 3
		set_collision_mask_bit(19,false)
	elif type == -1: #punch
		speed = 0
		damage = 1
		for n in get_tree().get_nodes_in_group("bjbullet"): if n != self: n.queue_free() #only 1 shot at a time
		set_collision_mask_bit(19,false)
	elif type == 3: #stabber
		speed = 83
		ranger = 10
		damage = 8
		for n in get_tree().get_nodes_in_group("bjbullet"): if n != self: n.queue_free() #only 1 shot at a time


func _on_Area2D_body_entered(body):
	if type == -1: $Sprite.frame = 7
	if body.is_in_group("bjouch"):
		body.take_damage(damage)
	if (type != 2) && (type != -1): queue_free()
