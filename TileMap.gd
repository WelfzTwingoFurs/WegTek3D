extends TileMap

func _ready():
	Worldconfig.TileMap = self
	if position != Vector2(0,0):
		print("fix tilemap position")
		position = Vector2(0,0)


func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		visible = 1
	else:
		visible = 0
