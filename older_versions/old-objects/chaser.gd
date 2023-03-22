extends "res://objects/sprite object physics.gd"

export var speed = 50
export var turn = 0.1
export(bool) var jumpy = false

var distanceXY = Vector2(0,0)

func _physics_process(_delta):
	motion = lerp(motion,  Vector2(speed, 0).rotated((position - Worldconfig.player.position).angle() + PI),  turn)
	
	if $AnimationPlayer != null:
		if (abs(motion.x) > 2) or (abs(motion.y) > 2):
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.stop()
			anim = 0
	
	distanceXY = position - Worldconfig.player.position
	rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - Worldconfig.player.position).angle() + PI/2, 0.05))
	
	if Input.is_action_just_pressed("mouse2"): jumpy = !jumpy
	
	if jumpy:
		if Worldconfig.player.positionZ > positionZ:
			jump()

func jump():
	if on_floor == true:
		motionZ += JUMP
		on_floor = false
	elif on_body == true:
		motionZ += JUMP
		on_body = false
		on_floor = false
