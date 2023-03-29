extends KinematicBody2D

var motion = Vector2()
var inputX = 0

func _physics_process(_delta):
	motion = move_and_slide(motion,Vector2(0,-1),true)
	if !is_on_floor(): motion.y += 5

func _process(_delta):
	motion.x = 50*inputX
	
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
	if body.is_in_group("OPplayer"):
		body.dead = true
		get_parent().get_parent().outdoor.frame = 6
