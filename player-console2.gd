extends Label

var change_checker = []
var on = 0

func _ready():
	change_checker = [OS.window_size*0, Worldconfig.zoom]
	visible = true

func _process(_delta):
	if Input.is_action_just_pressed("bug_console"):
		on += 1
		if on > 2:
			on = 0
		margin_bottom = 9999999
		margin_right = 9999999
	
	
	if change_checker != [OS.window_size, Worldconfig.zoom]:
		if Worldconfig.zoom > 0:
			#margin_bottom = (abs(get_viewport().size.y) / 2)
			margin_top    = (-abs(get_viewport().size.y)/ 2)
			margin_left   = (-abs(get_viewport().size.x)/ 2)
			#margin_right  = (abs(get_viewport().size.x) / 4)# / float(1)/Worldconfig.zoom
			
			#rect_scale = Vector2(float(1/Worldconfig.zoom),float(1/Worldconfig.zoom))
			rect_scale = Vector2( float(1)/Worldconfig.zoom,  float(1)/Worldconfig.zoom)*2
		
		else:
			#margin_bottom = (OS.window_size.y)  * (1-Worldconfig.zoom)/2
			#margin_right  = (OS.window_size.x)  * (1-Worldconfig.zoom)/4
			margin_top    = (-OS.window_size.y) * (1-Worldconfig.zoom)/2
			margin_left   = (-OS.window_size.x) * (1-Worldconfig.zoom)/2
			
			rect_scale = Worldconfig.Camera2D.zoom *2
			#change_checker = OS.window_size
	
	
	
	if on == 0:
		rect_scale /= 1.5
		if Engine.time_scale > 0.9:
			#text = str(Engine.get_frames_per_second())
			text = str(
				"render: p[",Worldconfig.player.array_walls.size(),
				"], s[",Worldconfig.player.array_sprites.size(),"].\n",
				"col: f[",Worldconfig.player.col_floors.size(),
				"], w[",Worldconfig.player.col_walls.size(),
				"], s[",Worldconfig.player.col_sprites.size(),"]...\n"
				,int(Engine.time_scale)," * ",Engine.get_frames_per_second())
		else:
			text = str(
				"render: p[",Worldconfig.player.array_walls.size(),
				"], s[",Worldconfig.player.array_sprites.size(),"].\n",
				"col: f[",Worldconfig.player.col_floors.size(),
				"], w[",Worldconfig.player.col_walls.size(),
				"], s[",Worldconfig.player.col_sprites.size(),"]...\n"
				,Engine.time_scale," * ",Engine.get_frames_per_second())
	
	
	elif on == 1:
		text = str(
			"[Worldconfig] config=",Worldconfig.config,", zoom=",Worldconfig.zoom,", Camera2D.zoom=",Worldconfig.Camera2D.zoom#,", step=",Worldconfig.step
			,";;  [Engine] time_scale=",Engine.time_scale,", FPS:",Engine.get_frames_per_second()#,";;  [OS] window_size=",OS.window_size
			,";; \n"
			,"[Worldconfig.player]"#,", change_checker=",Worldconfig.player.change_checker,"\n"
			," angles=",Worldconfig.player.angles,", draw_distance=",Worldconfig.player.draw_distance,", sky_stretch=",Worldconfig.player.sky_stretch,", skycolor=(",Worldconfig.player.skycolor,")"
			,", \n"
			," textures_on=",Worldconfig.player.textures_on,", UV_textures=",Worldconfig.player.UV_textures,", shading=",Worldconfig.player.shading,", cull_on=",Worldconfig.player.cull_on,", head_height=",Worldconfig.player.head_height,", jump=",Worldconfig.player.JUMP,", gravity=",Worldconfig.player.GRAVITY
			,", \n"
			,"vbob_max=",Worldconfig.player.vbob_max,", vbob_speed=",Worldconfig.player.vbob_speed,", vroll_multi=",Worldconfig.player.vroll_multi
			#,",\n"
			,", speed=",Worldconfig.player.speed,", rotate_rate=",Worldconfig.player.rotate_rate,", map_draw=",Worldconfig.player.map_draw
			#,", sky_stretch=",Worldconfig.player.sky_stretch,", skycolor=(",Worldconfig.player.skycolor,")"
			,";; \n"
			,"input_dir=",Worldconfig.player.input_dir,", move_dir=",Worldconfig.player.move_dir,", on_floor=",Worldconfig.player.on_floor,", rot_plus90=",Worldconfig.player.rot_plus90,", rot_minus90=",Worldconfig.player.rot_minus90,", midscreen=",Worldconfig.player.midscreen
			,"\n"
			,"position=(",int((Worldconfig.player.position.x)),",",int((Worldconfig.player.position.y)),"), positionZ=",Worldconfig.player.positionZ,", rotation_angle=",Worldconfig.player.rotation_angle,", motion=(",int((Worldconfig.player.motion.x)),",",int(Worldconfig.player.motion.y),"), motionZ=",int((Worldconfig.player.motionZ)),", motion.angle()-PI/2=",rad_overflow(Worldconfig.player.motion.angle()-PI/2)
			,"\n"
			,"lookingZ=",Worldconfig.player.lookingZ,", posZlookZ=",Worldconfig.player.posZlookZ,", vbob=",Worldconfig.player.vbob
			,", vroll_strafe_divi=",Worldconfig.player.vroll_strafe_divi," ,noclip=",Worldconfig.player.noclip
			,";; \n"
			,"array_walls(",Worldconfig.player.array_walls.size(),") =",Worldconfig.player.array_walls
			,"\n"
			,"array_sprites(",Worldconfig.player.array_sprites.size(),") =",Worldconfig.player.array_sprites
			,"\n"
			,"col_floors(",Worldconfig.player.col_floors.size(),")=",Worldconfig.player.col_floors
			,"\n"
			,"col_walls(",Worldconfig.player.col_walls.size(),")=",Worldconfig.player.col_walls
			,"\n"
			,"col_sprites(",Worldconfig.player.col_sprites.size(),")=",Worldconfig.player.col_sprites
			)
	
	elif on == 2:
		text = str("")
	
	





#		margin_bottom = (OS.window_size.y/2) 
#		margin_top    = (-OS.window_size.y/2)
#		margin_left   = (-OS.window_size.x/2)
#		margin_right  = (OS.window_size.x/2) 

func rad_overflow(N):
	if N > PI*2:
		N -= PI*2
	elif N < 0:
		N += PI*2
	
	return N
