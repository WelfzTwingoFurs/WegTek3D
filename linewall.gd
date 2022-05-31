extends StaticBody2D

onready var line = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b)]

onready var was_pos = position

func _ready():
	print(line)

func _process(_delta):
	if position != was_pos:
		line = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b)]
		was_pos = position
