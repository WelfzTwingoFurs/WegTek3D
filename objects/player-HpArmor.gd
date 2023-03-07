extends Label

func ready():
	visible = true
	change_checker = [OS.window_size*0, Worldconfig.zoom]

var change_checker = []

func _process(_delta):
	if change_checker != [OS.window_size, Worldconfig.zoom]:
		margin_left   = (-abs(get_viewport().size.x)/ 2)# / rect_scale.x
		margin_bottom = (abs(get_viewport().size.y)/ 2) / rect_scale.y
		rect_scale = Worldconfig.Camera2D.zoom * Worldconfig.player.hudscale
	
	text = str("   HP ",Worldconfig.player.health/10, "%\n")
