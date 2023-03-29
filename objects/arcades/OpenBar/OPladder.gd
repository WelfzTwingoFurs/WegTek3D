extends Area2D


var player = null

func _process(_delta):
	if player != null:
		player.ladder = self

func _on_ladder_body_entered(body):
	if body.is_in_group("OPfoe") && (body.position.y-position.y < 0):
		if (randi() % 3) == 0:
			body.position.y += 2
			body.inputX = 0
	
	
	if get_parent().get_parent().barrelshand == 0:
		if body.is_in_group("OPplayer"):
			#body.ladder = self #if !player: player = body
			if !player: player = body
	
	
	

func _on_ladder_body_exited(body):
	if body == player:
		player = null
	if body.is_in_group("OPplayer"):
		body.ladder = null
