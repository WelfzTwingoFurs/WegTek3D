extends StaticBody2D

func _process(_delta):
	if get_parent().get_parent().player.position.y > position.y:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
