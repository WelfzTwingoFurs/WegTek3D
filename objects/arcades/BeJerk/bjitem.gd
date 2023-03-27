extends Area2D

export var type = 0

func _ready():
	if type == 0:
		$Sprite.frame = 0
	elif type == 1:
		$Sprite.frame = 4
	elif type == 2:
		$Sprite.frame = 8

func _on_item_body_entered(body):
	if body.is_in_group("bjplayer"):
		if type == 0:
			body.weapon = 0
			get_parent().get_parent().get_parent().toptimer += 75
			get_parent().get_parent().get_parent().topstring = "## A PISTOL + FULL MAGAZINE!##"
			
	queue_free()
