extends Area2D

func _on_bounceback_body_entered(body):
	if body.is_in_group("OPplayer") && !body.is_on_floor():
		body.motion.x *= -1
