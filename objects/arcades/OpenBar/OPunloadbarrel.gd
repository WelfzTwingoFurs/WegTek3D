extends Area2D

var player = null

func _process(_delta):
	for n in get_parent().get_parent().barrelstop.size():
		if n < get_parent().get_parent().count_top:
			get_parent().get_parent().barrelstop[n].visible = true
		else:
			get_parent().get_parent().barrelstop[n].visible = false

func _on_unloadbarrel_body_entered(body):
	if body.is_in_group("OPplayer") && (get_parent().get_parent().barrelshand > 0):
		get_parent().get_parent().count_top += get_parent().get_parent().barrelshand
		get_parent().get_parent().barrelshand = 0
		
#		for n in get_parent().get_parent().barrelstop.size():
#			if n < get_parent().get_parent().count_top:
#				get_parent().get_parent().barrelstop[n].visible = true
#			else:
#				get_parent().get_parent().barrelstop[n].visible = false



