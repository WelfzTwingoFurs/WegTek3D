extends Area2D

var stopgame = true

func _on_arcade2_body_entered(body):
	if (Worldconfig.menu == null) && (body == Worldconfig.player):
		stopgame = true
		Worldconfig.menu = self
		spawn_game()


export var string = ""
export var game = preload("res://objects/arcades/BeJerk/bjNode2D.tscn")

var current_game = null
func spawn_game():
	var instance = game.instance()
	current_game = instance
	instance.be_player = false
	Worldconfig.Camera2D.call_deferred("add_child",instance)

func _process(_delta):
	if current_game != null:
		if Input.is_action_just_pressed("ply_exit"):
			stopgame = false
			Worldconfig.menu = null
			current_game.queue_free()
