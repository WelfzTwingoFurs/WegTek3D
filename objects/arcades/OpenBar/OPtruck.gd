extends Sprite

func _process(_delta):
	if !get_parent().get_parent().player.dead:
		if (get_parent().get_parent().delitimer < 1) or !get_parent().get_parent().bottom.bot_count:
			$AniPlay.play("deliver")
	else:
		$AniPlay.stop()

func shoot():
	get_parent().get_parent().deliver()
