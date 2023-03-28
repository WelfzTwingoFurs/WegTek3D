extends Area2D

func _on_queue_zone_body_entered(body):
	body.queue_free()
