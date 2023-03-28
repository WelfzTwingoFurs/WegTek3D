extends Area2D

export var type = 0

func _ready():
	if type == 0: #pistol
		$Sprite.frame = 0
	elif type == 1: #'noif
		$Sprite.frame = 4
	elif type == 2: #bö
		$Sprite.frame = 8

func _on_item_body_entered(body):
	if body.is_in_group("bjplayer"):
		get_parent().get_parent().get_parent().toptimer += 75
		if type == 0:
			body.weapon = 0
			get_parent().get_parent().get_parent().topstring = "PISTOL + FULL MAGAZINE!"
			get_parent().get_parent().get_parent().ammo = 20
		
		elif type == 1:
			body.weapon = 1
			get_parent().get_parent().get_parent().topstring = "DAGGER!"
	
		elif type == 2:
			body.weapon = 2
			get_parent().get_parent().get_parent().topstring = "PIERCING ARROWS!"
			get_parent().get_parent().get_parent().ammo = 20
		
		elif type == 3:
			body.weapon = 3
		
		elif type == 4:
			body.weapon = 4
		
		elif type == 5:
			body.weapon = 5
	
	queue_free()
