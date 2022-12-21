extends Node2D

export(bool) var kill

func _ready():
	if kill:
		queue_free()
	
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		visible = !visible
