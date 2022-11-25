extends "res://sprite object physics.gd"

const speed = 50

var distanceXY = Vector2(0,0)

func _physics_process(_delta):
	motion = Vector2(speed, speed).rotated((rotation_degrees))
	
	if motion != Vector2(0,0):
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
		anim = 0
	
	distanceXY = position - Worldconfig.player.position
	rotation_degrees = rad2deg((position - Worldconfig.player.position).angle() + PI/2)
	
	#if on_floor == 1 or (col_floors.size() == 0 && positionZ <= 0):
	#if Worldconfig.player.positionZ > positionZ:
	jump()
