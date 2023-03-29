extends Sprite

var timer = 0
var timer_range 
export var skin = 1
export var satisfy = false

func _ready():
	timer_range = (randi() % 20) + 20
	get_parent().get_parent().get_parent().queue_current += 1

func _physics_process(_delta):
	if !get_parent().get_parent().get_parent().player.dead:
		timer += 1
		if timer > timer_range: timer = -timer_range
		
		if timer < 0:
			if !satisfy:
				frame = 0+(skin*3)
			else:
				frame = 2+(skin*3)
				flip_h = true
		elif timer > 0:
			if !satisfy:
				frame = 1+(skin*3)
			else:
				frame = 2+(skin*3)
				flip_h = false
		
		else:#time = 0
			if !satisfy && (position.x - (-152+(16*queue_position)) < 10):
				position.y -= (randi() % 10)
				flip_h = true if (randi() % 2 == 0) else false
		
		if !satisfy:
			position.y = lerp(position.y,0,0.2)
			if queue_position > 0: position.x = lerp(position.x,-152+(16*queue_position),0.01/queue_position)
			elif (position.x > -152): position.x -= 1
		else:
			position.x = lerp(position.x,136,0.01)
		
		if queue_position < 0:
			if (position.x > -152): position.x -= 1
			else:
				get_parent().get_parent().get_parent().mug.frame = 0
				timer_range = 1000
				satisfy = true
				

var queue_position = 0

func not_under_1(x):
	if x < 1: x = 1
	return x
