extends KinematicBody2D

var motion = Vector2()
var input = Vector2()

func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = input*speed

func _process(_delta):
	if input == Vector2(): queue_free()
	
#	if OS.get_ticks_msec() % 9 == 0: modulate = Color(1,0,0)
#	elif OS.get_ticks_msec() % 8 == 0: modulate = Color(0,1,0)
#	elif OS.get_ticks_msec() % 7 == 0: modulate = Color(0,0,1)
#	elif OS.get_ticks_msec() % 6 == 0: modulate = Color(1,1,0)
#	elif OS.get_ticks_msec() % 5 == 0: modulate = Color(1,0,1)
#	elif OS.get_ticks_msec() % 4 == 0: modulate = Color(0,1,1)
#	elif OS.get_ticks_msec() % 3 == 0: modulate = Color(1,1,1)
#	elif OS.get_ticks_msec() % 2 == 0: modulate = Color(0,0,0)
	
	
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
	

var spawnpos = Vector2()
var type = 0
var speed = 1000
var ranger = 10
var damage = 5

func _ready():
	spawnpos = position
	if type == 0: # gands
		speed = 1000
		ranger = INF
		damage = 5
	elif type == 1: # 'noife
		speed = 250
		ranger = 10
		damage = 8
	elif type == 2: # bö
		speed = 500
		ranger = 75
		damage = 3
		set_collision_mask_bit(19,false)
		set_collision_mask_bit(16,false)
		set_collision_mask_bit(17,false)
	
	


func _on_Area2D_body_entered(body):
	if body.is_in_group("bjouch"):
		body.take_damage(damage)
	if type != 2: queue_free()
