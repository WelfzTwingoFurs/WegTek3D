extends Area2D

func _on_barrelchangeside_body_entered(body):
	if body.is_in_group("OPfoe"):
		body.inputX *= -1
