extends AnimationPlayer

export var dont = false

func _ready():
	if !dont:
		play("_ready")
	else:
		queue_free()
