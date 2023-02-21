extends AnimationPlayer

export var dont = false

func _ready():
	if !dont:
		play("_ready")
	else:
		queue_free()

var pause = false

#func _physics_process(_delta):
#	if Input.is_action_just_pressed("bug_animationplayer_pause"):
#		pause = !pause
#		if pause == true:
#			stop()
#		else:
#			play()
