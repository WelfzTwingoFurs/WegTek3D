extends Area2D

var player = false

func _on_deliverzone_body_entered(body):
	if body.is_in_group("OPplayer"):
		player = true
		body.jumpsfx = false

func _on_deliverzone_body_exited(body):
	if body.is_in_group("OPplayer") && player:
		player = false
		body.jumpsfx = true


export var comeearly = false

func _process(_delta):
	if player && (get_parent().get_parent().player.position.y < -53) && Input.is_action_just_pressed("arc_button1"):
		if get_parent().get_parent().mug.frame > 3:
			if comeearly && (get_parent().get_parent().mug.frame == 4) && (get_parent().get_parent().queue_current == 0):
				get_parent().get_parent().score += 50
				get_parent().get_parent().clients.shoot()
				get_parent().get_parent().clients.timer = get_parent().get_parent().clients.spawn_timer 
			
			
			get_parent().get_parent().queue -= 1
			get_parent().get_parent().count_top -= 1
			get_parent().get_parent().mug.frame += 1
			get_parent().get_parent().queue_current -= 1
			#if get_parent().get_parent().queue_current < -1:
			
			
			
			if get_parent().get_parent().mug.frame > 5:
				get_parent().get_parent().audio_square2.gate()
				get_parent().get_parent().player.dead = true
				get_parent( ).get_parent().mug.frame = 6
				get_parent().get_parent().outdoor.frame = 5
		else:
			if ((get_parent().get_parent().count_top > 0) or (get_parent().get_parent().mug.frame == 0)):
				get_parent().get_parent().mug.frame += 1
