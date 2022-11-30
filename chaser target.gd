extends "res://sprite object physics.gd"

const speed = 50

var distanceXY = Vector2(0,0)
export var position1 = Vector2(415,-2282)
export var position2 = Vector2(427,-2282)
var position_switch = true

func _physics_process(_delta):
	var target = Vector2(0,0)
	motion = lerp(motion,  Vector2(speed, 0).rotated((position - target).angle() + PI),  0.1)
	
	if position_switch:
		if (position == position1):# < Vector2(10,10):
			target = position2
			position_switch = !position_switch
	else:
		if (position == position2):# < Vector2(10,10):
			target = position1
			position_switch = !position_switch
	
	distanceXY = position - target
	rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - target).angle() + PI/2, 0.05))
	
	
	if Worldconfig.player.positionZ > positionZ:
		jump()
