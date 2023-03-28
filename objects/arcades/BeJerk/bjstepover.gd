extends Area2D


var has = false

func _on_stepover_body_entered(body):
	if !has:
		if body.is_in_group("bjplayer") or body.is_in_group("bjcar"):
			$Sprite.frame += 1
			has = true
			get_parent().get_parent().get_parent().toptimer += 15
			get_parent().get_parent().get_parent().topstring = str("CRUSH VEGETATION:+",get_parent().get_parent().get_parent().combo*150)
			get_parent().get_parent().get_parent().score += get_parent().get_parent().get_parent().combo*150
			get_parent().get_parent().get_parent().combo += 1
