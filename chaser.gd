extends "res://sprite object physics.gd"

const speed = 50

var distanceXY = Vector2(0,0)

func _physics_process(_delta):
	motion = lerp(motion,  Vector2(speed, 0).rotated((position - Worldconfig.player.position).angle() + PI),  0.1)
	
	if motion != Vector2(0,0):
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
		anim = 0
	
	distanceXY = position - Worldconfig.player.position
	rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - Worldconfig.player.position).angle() + PI/2, 0.05))
	
	
	if Worldconfig.player.positionZ > positionZ:
		jump()
