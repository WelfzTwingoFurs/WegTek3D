extends Node

# OLD Globally used variables #
var TileMap
var TileCol
var texture_size = 10

############# zoom #########
var config = 1
# 0 = Window stretches & Image keeps aspect-ratio
# 1 = Window & Image stretch together
var step = 0
var zoom = 1
#var zoom_config = 0
# 0 = Software exploit zoom-out
# 1 = Better and obvious Camera2D zoom-out
##################################

var player
var Camera2D
var playercar = null
onready var menu = null

var npcs = 0
var cars = 0

func _ready():
	menu = null

func _process(_delta):
	#print(playercar)
	### STOCK zoom configuration ###
	### zoom process ###
	
	if config == 0:
		if step == 0: # Viewport, Keep -- Window size = monitor, image stretches, keep aspect-ratio
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(OS.window_size.x, OS.window_size.y))
			OS.window_size = OS.get_screen_size() #Window size as screen
			OS.center_window() 
			
			step = 1
		
		
		elif step == 1: # Disabled, Ignore -- Window size /= zoom (zoom part 1), image doesn't stretch, keep vertical aspect-ratio
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(OS.window_size.x, OS.window_size.y))
			OS.window_size /= zoom 
			OS.center_window() # Window res/2
			
			step = 2
		
		
		elif step == 2: # Viewport, Keep --  Window size *= zoom (zoom OK), image stretches, keep aspect-ratio
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(OS.window_size.x, OS.window_size.y))
			OS.window_size *= zoom 
			OS.center_window() # Window res*2
			
			if OS.window_maximized:
				OS.window_maximized = false
				OS.window_maximized = true
			print("=  WORLDCONFIG: config=",config,", zoom=",zoom,";; [SceneTree] STRETCH_MODE_VIEWPORT, STRETCH_ASPECT_KEEP")
			step = -1
	
	
	
	
	elif config == 1:
		if step == 0:
			#OS.window_size = OS.get_screen_size()
			#OS.center_window() 
			OS.set_window_maximized(true)
			
			step = 1
		
		elif step == 1: # Disabled, Expand -- Window size stays, image doesn't stretch, doesn't care about aspect-ratio
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(OS.window_size.x, OS.window_size.y))
			
			step = -1
			print("=  WORLDCONFIG: config=",config,", zoom=",zoom,";; [SceneTree] STRETCH_MODE_DISABLED, STRETCH_ASPECT_EXPAND")
	
	
	
	
	######################################## Debugging commands below ##########
	
	if step == -1:
		if Input.is_action_just_pressed("bug_windivide"): # F1 - Half the zoom screen
			OS.window_size /= 2
			OS.set_window_maximized(false)
			step = 1
		
		if Input.is_action_just_pressed("bug_winmultiply"): # F2 - Double the zoom screen
			OS.window_size *= 2
			OS.set_window_maximized(false)
			step = 1
		
		if Input.is_action_just_pressed("bug_fillscreen"): # F3 - reset/fill screen (not fullscreen)
			config = 1
			zoom = 1
			Camera2D.zoom = Vector2(1,1)
			step = 0
		
		
		
		#if !Input.is_action_pressed("bug_closeeyes"):
		if !Worldconfig.player.map_on:
			if Input.is_action_just_pressed("bug_zoomplus"): # + Zoom in
				if zoom > 0:
					config = 0
					zoom += 1
					if zoom == 0:
						zoom = 1
					
					step = 1
					
					
					
				
				else:
					Camera2D.zoom -= Vector2(1,1)
					zoom += 1
					if zoom == 0:
						zoom = 1
					
					print("=  WORLDCONFIG: config=",config,", zoom=",zoom,", Camera2D.zoom=",Camera2D.zoom)
			
			
			if Input.is_action_just_pressed("bug_zoomminus"): # - Zoom out
				if zoom > 1:
					config = 0
					zoom -= 1
					if zoom == 0:
						zoom = -1
					
					step = 1
				
				else:
					Camera2D.zoom += Vector2(1,1)
					zoom -= 1
					if zoom == 0:
						zoom = -1
					
					print("=  WORLDCONFIG: config=",config,", zoom=",zoom,", Camera2D.zoom=",Camera2D.zoom)
			
			
			
			
#			if Input.is_action_just_pressed("bug_resplus"):
#				Camera2D.zoom += Vector2(1,1)
#				config = 0
#				zoom += 1
#				if zoom == 0:
#					zoom = 1
#
#				step = 1
			
		#if Input.is_action_just_pressed("bug_winstay"):
		#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(OS.window_size.x, OS.window_size.y))
		#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(OS.window_size.x, OS.window_size.y))
		#	
		
		
		
		
		
		if Input.is_action_just_pressed("bug_reset"): #5
			Engine.time_scale = 1
			var thefunctionreloadcurrentscenereturnsavaluebutthisvalueisneverused = get_tree()
			thefunctionreloadcurrentscenereturnsavaluebutthisvalueisneverused.reload_current_scene()
			#print("=  WORLDCONFIG: time=",Engine.time_scale)
		
		
		#if Input.is_action_just_pressed("bug_speeddown"): #9
		if Input.is_action_pressed("bug_speeddown"): #9
			if Engine.time_scale > 0.025:
				Engine.time_scale -= 0.025
		
		#elif Input.is_action_just_pressed("bug_speedup"): #10
		elif Input.is_action_pressed("bug_speedup"): #10
			Engine.time_scale += 0.025
		
		elif Input.is_action_just_released("bug_speeddown") or Input.is_action_just_released("bug_speedup"):
			print("=  WORLDCONFIG: time=",Engine.time_scale)
		
		elif Input.is_action_just_pressed("bug_speedres"): #11
			Engine.time_scale = 1
			print("=  WORLDCONFIG: time=",Engine.time_scale)
		
		elif Input.is_action_just_pressed("bug_speedstop"):#12
			Engine.time_scale = 0
			print("=  WORLDCONFIG: time=",Engine.time_scale)
