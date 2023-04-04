extends KinematicBody2D

var motion = Vector2()
var inputX = 0
var goingup = false

func _physics_process(_delta):
	motion = move_and_slide(motion,Vector2(0,-1),true)
	if !is_on_floor(): motion.y += 5

var speed = 50

func _ready():
	if get_parent().get_parent().levels.level > 7:
		speed *= 2

func _process(_delta):
	motion.x = speed*inputX
	
	if inputX == 0:
		$Sprite.frame = 8
		$AniPlay.stop()
		if is_on_floor(): inputX = 1 if randi() % 2 == 0 else -1
	else: $AniPlay.play("roll")
		
	
	if is_on_floor():
		motion.y /= 2
		$Col.disabled = false
		$Sprite.flip_h = input_to_flip(inputX)
	else:
		$Col.disabled = true


func input_to_flip(x):
	if x == 1: x = false
	elif x == -1: x = true
	return x


func _on_Area2D_body_entered(body):
	if body.is_in_group("OPplayer"):# && (body.position.y > position.y):
		#print(body.position.y,"  ",position.y,"   ",body.position.y-position.y)
		if !body.dead && (get_parent().get_parent().barrelshand < 3) && body.jumped && !body.is_on_floor() && (body.motion.y > 0) && (body.position.y - position.y) < -10:
			get_parent().get_parent().audio_square1.sfx_get(get_parent().get_parent().barrelshand)
			get_parent().get_parent().barrelshand += 1
			get_parent().get_parent().score += 10
			queue_free()
		else:
			if !body.dead: get_parent().get_parent().audio_square2.ai()
			body.dead = true
			body.ladderbusy = false
			body.ladder = null
			get_parent().get_parent().outdoor.frame = 6
