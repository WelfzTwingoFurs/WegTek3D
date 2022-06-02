extends Node

# Globally used variables #
var TileMap
var TileCol
var texture_size = 10

############# RESOLUTION #########
var WindowX
var WindowY

var step = 0
var resolution = 1
##################################

var dontrepeat = 0

func _process(_delta):
	### STOCK resolution configuration ###
	
	WindowX = OS.window_size.x
	WindowY = OS.window_size.y
	
	### Resolution process ###
	if step == 0:
		
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, Vector2(WindowX, WindowY))
		OS.center_window() # Viewport, Keep_Height
		OS.window_size.x = OS.get_screen_size().x # Window as <wide> as monitor
	
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_WIDTH, Vector2(WindowX, WindowY))
		OS.center_window() # Viewport, Keep_Widht
		OS.window_size.y = OS.get_screen_size().y # Window as ^tall^ as monitor

		step = 1
	
	
	elif step == 1:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(WindowX, WindowY))
		OS.window_size /= resolution # Disabled, Ignore
		OS.center_window() # Window res/2
		
		step = 2
	
	
	elif step == 2:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(WindowX, WindowY))
		OS.window_size *= resolution # Viewport, Keep
		OS.center_window() # Window res*2
		
		step = 3
	
	elif step == 3:
		if dontrepeat == 0:
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(WindowX, WindowY))
			OS.window_size /= 2
			dontrepeat = 1
		
		step = 4
	
	
	
	
	######################################## Debugging commands below ##########
	
	else:
		if Input.is_action_just_pressed("bug_resdivide"): # 1
			OS.window_size /= 2
			OS.center_window()
		
		if Input.is_action_just_pressed("bug_resmultiply"): # 2
			OS.window_size *= 2
			OS.center_window()
		
		if Input.is_action_just_pressed("bug_resagain"): # 3
			step = 0
		
		
		if Input.is_action_just_pressed("bug_reset"): #5
			Engine.time_scale = 1
			var cock = get_tree()
			
			cock.reload_current_scene()
		
		
		if Input.is_action_just_pressed("bug_resplus"):
				resolution += 1
				step = 0
		
		elif Input.is_action_just_pressed("bug_resminus"):
			if resolution > 1:
				resolution -= 1
				step = 0
			else:
				resolution -= 0.1
				step = 0
		
		
		
		if Input.is_action_just_pressed("bug_speeddown"):
			Engine.time_scale -= 0.2
		
		elif Input.is_action_just_pressed("bug_speedup"):
			Engine.time_scale += 0.2
		
		elif Input.is_action_just_pressed("bug_speedres"):
			Engine.time_scale = 1
		
		elif Input.is_action_just_pressed("bug_speedstop"):
			Engine.time_scale = 0
