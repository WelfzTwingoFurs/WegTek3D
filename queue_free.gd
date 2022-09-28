extends Node2D

export(bool) var kill

func _ready():
	if kill:
		queue_free()
