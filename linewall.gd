extends StaticBody2D

onready var line = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b)]

func _ready():
	print(line)
