extends "res://sprite object physics.gd"

export var speed = 50
export var turn = 0.1

var distanceXY = Vector2(0,0)

func _physics_process(_delta):
	motion = Vector2(speed, 0).rotated(rotation_degrees)
	
	$AnimationPlayer.play("_ready")
	
	#print(anim)
