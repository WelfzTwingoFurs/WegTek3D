extends Node

# Globally used variables #
var TileMap
var TileCol
var texture_size = 10

############# RESOLUTION #########
var config = 1
# 0 = Screen's aspect ratio, zooming in ## For sprite games, keeps pixels square
# 1 = Any window size, no auto-stretch  ## For 3D, window stretches free, rendering stretches with it
var step = 0
var resolution = 2
##################################

func _process(_delta):
	### STOCK resolution configuration ###
	### Resolution process ###
	
	if config == 0:
		if step == 0: # Viewport, Keep -- Window size = monitor, image stretches, keep aspect-ratio
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(OS.window_size.x, OS.window_size.y))
			OS.window_size = OS.get_screen_size() #Window size as screen
			OS.center_window() 
			
			step = 1
		
		
		elif step == 1: # Disabled, Ignore -- Window size /= resolution (zoom part 1), image doesn't stretch, keep vertical aspect-ratio
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(OS.window_size.x, OS.window_size.y))
			OS.window_size /= resolution 
			OS.center_window() # Window res/2
			
			step = 2
		
		
		elif step == 2: # Viewport, Keep --  Window size *= resolution (zoom OK), image stretches, keep aspect-ratio
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(OS.window_size.x, OS.window_size.y))
			OS.window_size *= resolution 
			OS.center_window() # Window res*2
			
			step = -1
	
	elif config == 1:
		if step == 0:
			OS.window_size = OS.get_screen_size()
			OS.center_window() 
			
			step = 1
		
		elif step == 1: # Disabled, Expand -- Window size stays, image doesn't stretch, doesn't care about aspect-ratio
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(OS.window_size.x, OS.window_size.y))
			
			step = -1
	
	
	
	
	######################################## Debugging commands below ##########
	
	if step == -1:
		if Input.is_action_just_pressed("bug_resdivide"): # F1 - Half the resolution screen
			OS.window_size /= 2
			step = 1
		
		if Input.is_action_just_pressed("bug_resmultiply"): # F2 - Double the resolution screen
			OS.window_size *= 2
			step = 1
		
		if Input.is_action_just_pressed("bug_fillscreen"): # F3 - fillscreen (not fullscreen)
			config = 1
			step = 0
		
		
		
		
		if Input.is_action_just_pressed("bug_zoomplus"): # + Zoom in
				config = 0
				resolution += 1
				step = 1
		
		if Input.is_action_just_pressed("bug_zoomminus"): # - Zoom out
			if resolution > 1:
				config = 0
				resolution -= 1
				step = 1
		
		
		
		
		if Input.is_action_just_pressed("bug_reset"): #5
			Engine.time_scale = 1
			var thefunctionreloadcurrentscenereturnsavaluebutthisvalueisneverused = get_tree()
			thefunctionreloadcurrentscenereturnsavaluebutthisvalueisneverused.reload_current_scene()
		
		
		if Input.is_action_just_pressed("bug_speeddown"): #9
			Engine.time_scale -= 0.2
		
		elif Input.is_action_just_pressed("bug_speedup"): #10
			Engine.time_scale += 0.2
		
		elif Input.is_action_just_pressed("bug_speedres"): #11
			Engine.time_scale = 1
		
		elif Input.is_action_just_pressed("bug_speedstop"):#12
			Engine.time_scale = 0
