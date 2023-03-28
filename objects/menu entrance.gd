extends Area2D

var stopgame = false

export var string = "Do you wish to enter? [Y/N]"
export var interior = "res://objects/scene-pieces-guilhermina/interior B1downie arcade.tscn"

func _on_entrance_body_entered(body):
	if (body == Worldconfig.player):
		Worldconfig.menu = self

func _process(_delta):
	if Worldconfig.menu == self:
		if Input.is_action_just_pressed("ply_yes"):
			Worldconfig.menu = null
			var _thefunctionchangescenereturnsavaluebutthisvalueisneverused = get_tree().change_scene(interior)
		elif Input.is_action_just_pressed("ply_no"):
			Worldconfig.menu = null
