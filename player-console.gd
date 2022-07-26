extends Label

#var change_checker = Vector2(0,0)

func _process(_delta):
	if Input.is_action_just_pressed("bug_console"):
		visible = !visible
		margin_bottom = 9999999
		margin_right = 9999999
	
	
	if visible:
	#if change_checker != OS.window_size:
		if Worldconfig.zoom > 0:
			#margin_bottom = (abs(get_viewport().size.y) / 2)
			margin_top    = (-abs(get_viewport().size.y)/ 2)
			margin_left   = (-abs(get_viewport().size.x)/ 2)
			#margin_right  = (abs(get_viewport().size.x) / 4)# / float(1)/Worldconfig.zoom
			
			#rect_scale = Vector2(float(1/Worldconfig.zoom),float(1/Worldconfig.zoom))
			rect_scale = Vector2( float(1)/Worldconfig.zoom,  float(1)/Worldconfig.zoom)*2
		
		else:
			#margin_bottom = (OS.window_size.y)  * (1-Worldconfig.zoom)/2
			margin_top    = (-OS.window_size.y) * (1-Worldconfig.zoom)/2
			margin_left   = (-OS.window_size.x) * (1-Worldconfig.zoom)/2
			#margin_right  = (OS.window_size.x)  * (1-Worldconfig.zoom)/4
			
			rect_scale = Worldconfig.Camera2D.zoom *2
			#change_checker = OS.window_size
		
		
		text = str(
			"[Worldconfig] config=",Worldconfig.config,", zoom=",Worldconfig.zoom,", Camera2D.zoom=",Worldconfig.Camera2D.zoom#,", step=",Worldconfig.step
			,";;  [Engine] time_scale=",Engine.time_scale,", FPS:",Engine.get_frames_per_second()#,";;  [OS] window_size=",OS.window_size
			,";; \n"
			,"[Worldconfig.player]"#,", change_checker=",Worldconfig.player.change_checker,"\n"
			,", angles=",Worldconfig.player.angles,", draw_distance=",Worldconfig.player.draw_distance
			,", vbob_max=",Worldconfig.player.vbob_max,", vbob_speed=",Worldconfig.player.vbob_speed,", vroll_multi=",Worldconfig.player.vroll_multi
			#,",\n"
			,", speed=",Worldconfig.player.speed,", rotate_rate=",Worldconfig.player.rotate_rate,", map_draw=",Worldconfig.player.map_draw
			#,", sky_stretch=",Worldconfig.player.sky_stretch,", skycolor=(",Worldconfig.player.skycolor,")"
			,"\n"
			,"input_dir=",Worldconfig.player.input_dir,", motion_dir=",Worldconfig.player.move_dir,", rot_plus90=",Worldconfig.player.rot_plus90,", rot_minus90=",Worldconfig.player.rot_minus90,", midscreen=",Worldconfig.player.midscreen
			,"\n"
			,"position=(",int((Worldconfig.player.position.x)),",",int((Worldconfig.player.position.y)),"), positionZ=",Worldconfig.player.positionZ,", motion=(",int((Worldconfig.player.motion.x)),",",int((Worldconfig.player.motion.y)),"), rotation_angle=",Worldconfig.player.rotation_angle
			,"\n"
			,"lookingZ=",Worldconfig.player.lookingZ,", posZlookZ=",Worldconfig.player.posZlookZ,", vbob=",Worldconfig.player.vbob
			,", vroll_strafe_divi=",Worldconfig.player.vroll_strafe_divi
			,"\n"
			,"array_walls(",Worldconfig.player.array_walls.size(),")","=",Worldconfig.player.array_walls
			)








#		margin_bottom = (OS.window_size.y/2) 
#		margin_top    = (-OS.window_size.y/2)
#		margin_left   = (-OS.window_size.x/2)
#		margin_right  = (OS.window_size.x/2) 
