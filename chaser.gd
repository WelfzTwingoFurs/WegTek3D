extends "res://sprite object physics.gd"

var motion = Vector2()
var rotation_angle = 0
const speed = 50

var distanceXY = Vector2(0,0)
var input_dir = Vector2(0,0)

func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = Vector2(speed*input_dir.x, speed*input_dir.y)
	
	#if Input.is_action_pressed("ui_up"):input_dir.y = 1
	#elif Input.is_action_pressed("ui_down"):input_dir.y = -1
	#else: input_dir.y = 0
	
	if motion != Vector2(0,0):
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
		anim = 0
	
	distanceXY = position - Worldconfig.player.position
	
	rotation_degrees = rad2deg((position - Worldconfig.player.position).angle() + PI/2)
	
	#print(rad2deg((position - Worldconfig.player.position).angle() + PI/2))
