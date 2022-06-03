extends StaticBody2D

onready var points = []
var was_points = []

export var heights = [1,1,1,1,1,1,1,1,1,1]

func _ready():
	for n in $CollisionPolygon2D.polygon.size():
		points.append(to_global($CollisionPolygon2D.polygon[n]))
	was_points = points

func _process(_delta):
	if was_points != points:
		for n in $CollisionPolygon2D.polygon.size():
			points[n] = (to_global($CollisionPolygon2D.polygon[n]))
		
		was_points = points
