extends Area2D


var player = null
export var broken = false

func _process(_delta):
	if broken: $Sprite.frame = 1
	else: $Sprite.frame = 0
	
	if (player != null) && !get_parent().get_parent().barrelshand:
		player.ladder = self
		if Input.is_action_just_pressed("arc_button1"):
			player.ladder = null
			player = null
	elif (player != null) && get_parent().get_parent().barrelshand && (player.position.y - position.y < -7) && player.is_on_floor():
		if Input.is_action_just_pressed("arc_down"):
			player.jumped = true
			player.position.y += 9

func _on_ladder_body_entered(body):
	if body.is_in_group("OPfoe") && (body.position.y-position.y < 0):# && !body.goingup:
		if (randi() % 3) == 0:
			body.position.y += 2
			body.inputX = 0
	
	
	if body.is_in_group("OPplayer"):
		#body.ladder = self #if !player: player = body
		if !broken:
			if !player: player = body
		elif body.position.y - position.y < -7:
			body.motion.y = 250
			body.jumped = true
			body.position.y += 1
	
	
	

func _on_ladder_body_exited(body):
	if body == player:
		player = null
	if body.is_in_group("OPplayer"):
		if body.ladderbusy && Input.is_action_pressed("arc_up"): body.jumped = false
		body.ladder = null
