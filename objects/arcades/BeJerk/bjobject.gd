extends StaticBody2D


var has = false

func take_damage(_dmg):
	if !has:
		$Sprite.frame += 1
		has = true
		get_parent().get_parent().get_parent().score += get_parent().get_parent().get_parent().combo*200
		get_parent().get_parent().get_parent().toptimer += 50
		#get_parent().get_parent().get_parent().topstring = "-                            -"
		get_parent().get_parent().get_parent().topstring = str("PROPRIETY DAMAGE:X",get_parent().get_parent().get_parent().combo,"!+",get_parent().get_parent().get_parent().combo*200)
		get_parent().get_parent().get_parent().combo += 1
