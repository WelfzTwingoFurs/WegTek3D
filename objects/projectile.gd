extends "res://sprite object physics.gd"

export var speed = 350

func _ready():
	$AnimationPlayer.play("_ready")
	motion = Vector2(speed, 0).rotated(rotation_degrees)
	add_collision_exception_with(Worldconfig.player)
	
	$ColArea/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false
