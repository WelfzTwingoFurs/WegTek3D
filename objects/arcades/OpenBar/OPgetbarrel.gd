extends Area2D

var player = false

func _on_getbarrel_body_entered(body):
	if body.is_in_group("OPplayer"):
		#player = body
		player = true
		body.jumpsfx = false
	
	elif body.is_in_group("OPfoe"):
		body.z_index = -2


func _on_getbarrel_body_exited(body):
	if (player != null) && body.is_in_group("OPplayer"):
		player = false
		body.jumpsfx = true
	
	elif body.is_in_group("OPfoe"):
		if (bot_count < 9): bot_count += 1
		else:
			get_parent().get_parent().player.dead = true
			get_parent().get_parent().outdoor.frame = 3
			bot_count = 0
		body.queue_free()

export var bot_count = 9

#func _ready():
#	get_parent().get_parent().barrelsbot

func _process(_delta):
	if player:
		if get_parent().get_parent().barrelshand < 3:
			if Input.is_action_just_pressed("ply_jump") && (bot_count > 0):
				bot_count -= 1
				get_parent().get_parent().audio_square1.sfx_get(get_parent().get_parent().barrelshand)
				get_parent().get_parent().barrelshand += 1
			elif Input.is_action_just_pressed("ply_down") && (bot_count < 9) && (get_parent().get_parent().barrelshand > 0):
				bot_count += 1
				get_parent().get_parent().audio_square1.sfx_get(get_parent().get_parent().barrelshand)
				get_parent().get_parent().barrelshand -= 1
		
		elif Input.is_action_just_pressed("ply_down") && (bot_count < 9) && (get_parent().get_parent().barrelshand > 0):
			bot_count += 1
			get_parent().get_parent().audio_square1.sfx_get(get_parent().get_parent().barrelshand)
			get_parent().get_parent().barrelshand -= 1
		
	
	for n in 9:#get_parent().get_parent().barrelsbot.size():
		if n < bot_count:
			get_parent().get_parent().barrelsbot[n].visible = true
		else:
			get_parent().get_parent().barrelsbot[n].visible = false
