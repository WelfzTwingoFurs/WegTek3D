extends Label

func ready():
	visible = true
	change_checker = [OS.window_size*0, Worldconfig.zoom]

var change_checker = []

func _process(_delta):
	if change_checker != [OS.window_size, Worldconfig.zoom]:
		margin_right   = (abs(get_viewport().size.x)/ 2) / rect_scale.x
		margin_bottom = (abs(get_viewport().size.y)/ 2) / rect_scale.y
		rect_scale = Worldconfig.Camera2D.zoom * Worldconfig.player.hudscale
	

	
	if Worldconfig.playercar != null:# Worldconfig.player.guninv == -1:
		text = str(
			"[",int((Worldconfig.playercar.motion.length())/50),"]-KM/H   \n",
			"[",Worldconfig.playercar.gear_in,"/",Worldconfig.playercar.gears,"]-GEAR   \n",
			"[",int(Worldconfig.playercar.motion.length()/(Worldconfig.playercar.max_speed/(float(Worldconfig.playercar.gears)/not_zero(Worldconfig.playercar.gear_in)))*100),"%]- RPM   ")
		#print(Worldconfig.playercar.transform.x)
	
	
	
	
	elif Worldconfig.player.guninv == 1:
		text = str(" FISTS   \n")
	
	elif  Worldconfig.player.guninv == 2:
		text = str("[",Worldconfig.player.ammo2loaded,"/",Worldconfig.player.ammo2stock,"]-PISTOL   \n")
	
	if (Worldconfig.player.guninv == 0) && (Worldconfig.playercar == null):
		visible = 0
	else:
		visible = 1

func not_zero(n):
	if n == 0:
		return 1
	else:
		return n
