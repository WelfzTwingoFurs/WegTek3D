extends Area2D

export var level = preload("res://objects/car Escort.tscn")
var am

func _on_LoadingZone_body_entered(body):
	if (body == Worldconfig.player) or (body == Worldconfig.playercar):
		var instance = level.instance()
		am = instance
		am.position = Vector2(0,0)
		Worldconfig.player.skip_frame()
		get_parent().call_deferred("add_child",instance)


func _on_LoadingZone_body_exited(body):
	if (body == Worldconfig.player) or (body == Worldconfig.playercar):
		if am != null:
			Worldconfig.player.skip_frame()
			am.queue_free()
