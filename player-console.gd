extends Label

#var change_checker = Vector2(0,0)

func _process(_delta):
	if Input.is_action_just_pressed("bug_console"):
		visible = !visible
	
	
	if visible:
	#if change_checker != OS.window_size:
		if Worldconfig.zoom > 0:
			margin_bottom = (abs(get_viewport().size.y) / 2)
			margin_top    = (-abs(get_viewport().size.y)/ 2)
			margin_left   = (-abs(get_viewport().size.x)/ 2)
			margin_right  = (abs(get_viewport().size.x) / 2)# / float(1)/Worldconfig.zoom
			
			#rect_scale = Vector2(float(1/Worldconfig.zoom),float(1/Worldconfig.zoom))
			rect_scale = Vector2( float(1)/Worldconfig.zoom,  float(1)/Worldconfig.zoom)*2
		
		else:
			margin_bottom = (OS.window_size.y)  * (1-Worldconfig.zoom)/2
			margin_top    = (-OS.window_size.y) * (1-Worldconfig.zoom)/2
			margin_left   = (-OS.window_size.x) * (1-Worldconfig.zoom)/2
			margin_right  = (OS.window_size.x)  * (1-Worldconfig.zoom)/2
			
			rect_scale = Worldconfig.Camera2D.zoom *2
			#change_checker = OS.window_size
		
		
		text = str(
			"[Engine] time_scale=",Engine.time_scale,";;  [OS] window_size=",OS.window_size,
			";; \n",
			"[Worldconfig] config=",Worldconfig.config,", zoom=",Worldconfig.zoom,", Camera2D.zoom=",Worldconfig.Camera2D.zoom,", step=",Worldconfig.step,
			";; \n",
			"...not much else to type here right now but I felt like making it"
			)








#		margin_bottom = (OS.window_size.y/2) 
#		margin_top    = (-OS.window_size.y/2)
#		margin_left   = (-OS.window_size.x/2)
#		margin_right  = (OS.window_size.x/2) 
