extends TileMap

func _ready():
	Worldconfig.TileMap = self
	if position != Vector2(0,0):
		print("fix tilemap position")
		position = Vector2(0,0)
	
	#visible = false


#func _process(_delta):
#	if visible == true:
#		if Input.is_action_just_pressed("ui_accept"):
#			visible = false
#	else:
#		if Input.is_action_just_pressed("ui_accept"):
#			visible = true
