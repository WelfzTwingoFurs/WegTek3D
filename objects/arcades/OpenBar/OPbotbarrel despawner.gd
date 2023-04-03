extends Area2D

func _on_botbarrel_despawner_body_entered(body):
	if body.is_in_group("OPfoe"):
		if body.goingup:
			get_parent().get_parent().count_top +=1
			body.queue_free()
		else:
			body.inputX *= -1
