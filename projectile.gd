extends "res://sprite object physics.gd"

export var speed = 350
export var turn = 0.1

var distanceXY = Vector2(0,0)

func _ready():
	$AnimationPlayer.play("_ready")
	motion = Vector2(speed, 0).rotated(rotation_degrees)
