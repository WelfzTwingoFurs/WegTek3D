extends KinematicBody2D

export var positionZ = 0
export var anim = 0
export var scale_extra = Vector2(float(1),float(1))
export var texture = "res://assets/sprites 8rot.png"
export var vframes = 4
export var hframes = 10
export var rotations = 4

func _ready():
	if $CollisionShape2D.position != Vector2(0,0):
		position = to_global($CollisionShape2D.position)
		$CollisionShape2D.position = Vector2(0,0)
