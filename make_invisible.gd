extends Node2D

func _ready():
	visible = false

func _process(_delta):
	if visible == true:
		if Input.is_action_just_pressed("ui_accept"):
			visible = false
	else:
		if Input.is_action_just_pressed("ui_accept"):
			visible = true
