extends Node2D

export var level = 0

var default_tiles = []

var readyshit = false

func _process(_delta):
	if !readyshit && get_parent().tiles:
		for n in 28:#how many verical tiles
			for m in 32:
				default_tiles.append(get_parent().tiles.get_cell(m-16,n-14))
		
		#print(default_tiles)
		readyshit = true
		
	
	if level == 0:
		get_parent().score = 0
		nextlevel()
	elif (get_parent().total_barrels == 0):
		if !get_parent().player.dead: $AniPlay.play("next")
		else: $AniPlay.stop()
	
	
	if Input.is_action_just_pressed("ply_car_radio"):
		if get_parent().audio_triangle.is_playing():
			get_parent().audio_triangle.stop()
		else:
			get_parent().audio_triangle.play()

func buildlevel():
	for n in 28:#how many verical tiles
		for m in 32:
			#default_tiles.push_back(get_parent().tiles.get_cell(m-16,n-14))
			get_parent().tiles.set_cellv(Vector2(m-16,n-14), default_tiles[(n*32)+m])

func gameoff():
	for n in get_parent().clients.get_children():
		n.queue_free()
	
	for n in get_parent().BG.get_children():
		if n.is_in_group("OPfoe"):
			n.queue_free()
	
	for n in get_parent().BG.get_children():
		if n.is_in_group("OPladder"):
			n.queue_free()
	
	get_parent().queue_current = 0
	get_parent().barrelshand = 1
	get_parent().count_top = 0
	get_parent().bottom.bot_count = 0
	get_parent().clients.spawncounter = 0
	get_parent().player.ladderbusy = true
	get_parent().player.dead = true
	get_parent().audio_triangle.stop()

func start():
	level = -1
	get_parent().barrelshand = 0
	nextlevel()


func unload():
	var children = 0
	for n in get_parent().clients.get_children():
		n.queue_free()
		children +=1
	
	if !get_parent().player.dead && (children == 0):
		get_parent().score += 500
	
	for n in get_parent().BG.get_children():
		if n.is_in_group("OPfoe"):
			n.queue_free()
	
	for n in get_parent().BG.get_children():
		if n.is_in_group("OPladder"):
			n.queue_free()
	
	get_parent().queue_current = 0
	get_parent().barrelshand = 0
	get_parent().count_top = 0
	get_parent().bottom.bot_count = 0
	get_parent().clients.spawncounter = 0
	get_parent().mug.frame = 0
	get_parent().outdoor.frame = 4
	


func reload():
	get_parent().lives -= 1
	get_parent().audio_triangle.stop()
	get_parent().audio_triangle.play()
	unload()
	loadlevel()

func nextlevel():
	level +=1
	if level != 1: get_parent().score += (level*1000)+100
	get_parent().audio_triangle.radio()
	loadlevel()
	
	if level < 9:
		selected_level = level
	else:
		selected_level = (randi() % 8) +1


var selected_level = 0

func loadlevel():
	buildlevel()
	
	get_parent().outdoor.frame = 0
	get_parent().player.jumped = true
	get_parent().player.ladderbusy = true
	get_parent().player.falldist = 103
	get_parent().player.position = Vector2(57,103)
	get_parent().player.dead = false
	get_parent().player.ladderbusy = false
	
	
	#level = 8
	
	if selected_level == 0: pass
	
#	elif selected_level == 8:
#		get_parent().count_top = 1
#		get_parent().bottom.bot_count = 0
#		get_parent().clients.spawn_timer = 100
#		get_parent().spawnertimer.basetimer = 9999
#		get_parent().spawnertimer.rand_extra = 1
	
	elif selected_level == 8:
		get_parent().count_top = 1
		get_parent().bottom.bot_count = 0
		get_parent().clients.spawn_timer = 350
		get_parent().spawnertimer.basetimer = 99999
		shoot_ladder(Vector2(-112,56),false)
		shoot_ladder(Vector2(-96,16),false)
		shoot_ladder(Vector2(-40,48),false)
		shoot_ladder(Vector2(0,48),false)
		shoot_ladder(Vector2(56,24),false)
		shoot_ladder(Vector2(-40,-24),false)
		shoot_ladder(Vector2(8,-16),false)
		get_parent().spawnertimer.timer = 99999
		
		get_parent().tiles.set_cellv(Vector2(-14,8),3)
		get_parent().tiles.set_cellv(Vector2(-14,9),3)
		get_parent().tiles.set_cellv(Vector2(-13,9),3)
		get_parent().tiles.set_cellv(Vector2(-13,10),3)
		get_parent().tiles.set_cellv(Vector2(-12,10),3)
		get_parent().tiles.set_cellv(Vector2(-12,11),3)
		get_parent().tiles.set_cellv(Vector2(-11,11),3)
		get_parent().tiles.set_cellv(Vector2(-11,12),3)
		get_parent().tiles.set_cellv(Vector2(-10,12),3)
		
		get_parent().tiles.set_cellv(Vector2(-12,9),3)
		get_parent().tiles.set_cellv(Vector2(-11,9),3)
		get_parent().tiles.set_cellv(Vector2(-10,9),3)
		get_parent().tiles.set_cellv(Vector2(-9,9),3)
		get_parent().tiles.set_cellv(Vector2(-8,9),3)
		get_parent().tiles.set_cellv(Vector2(-7,9),3)
		get_parent().tiles.set_cellv(Vector2(-6,9),3)
		get_parent().tiles.set_cellv(Vector2(-5,9),3)
		get_parent().tiles.set_cellv(Vector2(-4,9),3)
		get_parent().tiles.set_cellv(Vector2(-3,9),3)
		get_parent().tiles.set_cellv(Vector2(-2,9),3)
		get_parent().tiles.set_cellv(Vector2(-1,9),3)
		get_parent().tiles.set_cellv(Vector2(0,9),3)
		get_parent().tiles.set_cellv(Vector2(1,9),3)
		get_parent().tiles.set_cellv(Vector2(2,9),3)
		get_parent().tiles.set_cellv(Vector2(2,8),3)
		get_parent().tiles.set_cellv(Vector2(3,8),3)
		get_parent().tiles.set_cellv(Vector2(3,7),3)
		get_parent().tiles.set_cellv(Vector2(4,7),3)
		get_parent().tiles.set_cellv(Vector2(4,6),3)
		get_parent().tiles.set_cellv(Vector2(5,6),3)
		get_parent().tiles.set_cellv(Vector2(5,5),3)
		get_parent().tiles.set_cellv(Vector2(6,5),3)
		get_parent().tiles.set_cellv(Vector2(6,4),3)
		
		get_parent().tiles.set_cellv(Vector2(4,5),3)
		get_parent().tiles.set_cellv(Vector2(3,5),3)
		get_parent().tiles.set_cellv(Vector2(2,5),3)
		get_parent().tiles.set_cellv(Vector2(1,5),3)
		get_parent().tiles.set_cellv(Vector2(0,5),3)
		get_parent().tiles.set_cellv(Vector2(-1,5),3)
		get_parent().tiles.set_cellv(Vector2(-2,5),3)
		get_parent().tiles.set_cellv(Vector2(-3,5),3)
		get_parent().tiles.set_cellv(Vector2(-4,5),3)
		get_parent().tiles.set_cellv(Vector2(-5,5),3)
		get_parent().tiles.set_cellv(Vector2(-6,5),3)
		get_parent().tiles.set_cellv(Vector2(-7,5),3)
		get_parent().tiles.set_cellv(Vector2(-8,5),3)
		get_parent().tiles.set_cellv(Vector2(-9,5),3)
		get_parent().tiles.set_cellv(Vector2(-10,5),3)
		
		get_parent().tiles.set_cellv(Vector2(-10,4),3)
		get_parent().tiles.set_cellv(Vector2(-11,4),3)
		get_parent().tiles.set_cellv(Vector2(-11,3),3)
		get_parent().tiles.set_cellv(Vector2(-12,3),3)
		get_parent().tiles.set_cellv(Vector2(-12,2),3)
		get_parent().tiles.set_cellv(Vector2(-13,2),3)
		get_parent().tiles.set_cellv(Vector2(-13,1),3)
		get_parent().tiles.set_cellv(Vector2(-14,1),3)
		get_parent().tiles.set_cellv(Vector2(-14,0),3)
		
		get_parent().tiles.set_cellv(Vector2(-12,1),3)
		get_parent().tiles.set_cellv(Vector2(-11,1),3)
		get_parent().tiles.set_cellv(Vector2(-10,1),3)
		get_parent().tiles.set_cellv(Vector2(-9,1),3)
		get_parent().tiles.set_cellv(Vector2(-8,1),3)
		get_parent().tiles.set_cellv(Vector2(-7,1),3)
		get_parent().tiles.set_cellv(Vector2(-6,1),3)
		get_parent().tiles.set_cellv(Vector2(-5,1),3)
		get_parent().tiles.set_cellv(Vector2(-4,1),3)
		get_parent().tiles.set_cellv(Vector2(-3,1),3)
		get_parent().tiles.set_cellv(Vector2(-2,1),3)
		get_parent().tiles.set_cellv(Vector2(-1,1),3)
		get_parent().tiles.set_cellv(Vector2(0,1),3)
		get_parent().tiles.set_cellv(Vector2(1,1),3)
		get_parent().tiles.set_cellv(Vector2(2,1),3)
		
		get_parent().tiles.set_cellv(Vector2(2,0),3)
		get_parent().tiles.set_cellv(Vector2(3,0),3)
		get_parent().tiles.set_cellv(Vector2(3,-1),3)
		get_parent().tiles.set_cellv(Vector2(4,-1),3)
		get_parent().tiles.set_cellv(Vector2(4,-2),3)
		get_parent().tiles.set_cellv(Vector2(5,-2),3)
		get_parent().tiles.set_cellv(Vector2(5,-3),3)
		get_parent().tiles.set_cellv(Vector2(6,-3),3)
		get_parent().tiles.set_cellv(Vector2(6,-4),3)
		
		get_parent().tiles.set_cellv(Vector2(4,-3),3)
		get_parent().tiles.set_cellv(Vector2(3,-3),3)
		get_parent().tiles.set_cellv(Vector2(2,-3),3)
		get_parent().tiles.set_cellv(Vector2(1,-3),3)
		get_parent().tiles.set_cellv(Vector2(0,-3),3)
		get_parent().tiles.set_cellv(Vector2(-1,-3),3)
		get_parent().tiles.set_cellv(Vector2(-2,-3),3)
		get_parent().tiles.set_cellv(Vector2(-3,-3),3)
		get_parent().tiles.set_cellv(Vector2(-4,-3),3)
		get_parent().tiles.set_cellv(Vector2(-5,-3),3)
		get_parent().tiles.set_cellv(Vector2(-6,-3),3)
		get_parent().tiles.set_cellv(Vector2(-7,-3),3)
		get_parent().tiles.set_cellv(Vector2(-8,-3),3)
		get_parent().tiles.set_cellv(Vector2(-9,-3),3)
		get_parent().tiles.set_cellv(Vector2(-10,-3),3)
		get_parent().tiles.set_cellv(Vector2(-11,-3),3)
		get_parent().tiles.set_cellv(Vector2(-12,-3),3)
		get_parent().tiles.set_cellv(Vector2(-13,-3),3)
		get_parent().tiles.set_cellv(Vector2(-14,-3),3)
		get_parent().tiles.set_cellv(Vector2(-14,-4),3)
		#get_parent().tiles.set_cellv(Vector2(7,5),3)
	
	
	
	
	
	
	elif selected_level == 7:
		get_parent().count_top = 3
		get_parent().bottom.bot_count = 0
		get_parent().clients.spawn_timer = 300
		get_parent().spawnertimer.basetimer = 25
		get_parent().spawnertimer.rand_extra = 1
		
		
		get_parent().tiles.set_cellv(Vector2(-12,9),3)
		get_parent().tiles.set_cellv(Vector2(-11,9),3)
		get_parent().tiles.set_cellv(Vector2(-10,9),3)
		get_parent().tiles.set_cellv(Vector2(-9,9),3)
		
		get_parent().tiles.set_cellv(Vector2(-14,8),3)
		get_parent().tiles.set_cellv(Vector2(-14,9),3)
		get_parent().tiles.set_cellv(Vector2(-13,9),3)
		get_parent().tiles.set_cellv(Vector2(-13,10),3)
		#get_parent().tiles.set_cellv(Vector2(-12,10),3)
		#get_parent().tiles.set_cellv(Vector2(-12,11),3)
		get_parent().tiles.set_cellv(Vector2(-11,11),3)
		get_parent().tiles.set_cellv(Vector2(-11,12),3)
		get_parent().tiles.set_cellv(Vector2(-10,12),3)
		
		get_parent().tiles.set_cellv(Vector2(1,9),3)
		get_parent().tiles.set_cellv(Vector2(2,9),3)
		get_parent().tiles.set_cellv(Vector2(2,8),3)
		get_parent().tiles.set_cellv(Vector2(3,8),3)
		get_parent().tiles.set_cellv(Vector2(3,7),3)
		get_parent().tiles.set_cellv(Vector2(6,4),3)
		#get_parent().tiles.set_cellv(Vector2(4,7),3)
		#
		get_parent().tiles.set_cellv(Vector2(5,6),3)
		get_parent().tiles.set_cellv(Vector2(5,5),3)
		get_parent().tiles.set_cellv(Vector2(6,5),3)
	
		get_parent().tiles.set_cellv(Vector2(1,5),3)
		get_parent().tiles.set_cellv(Vector2(2,5),3)
		get_parent().tiles.set_cellv(Vector2(3,5),3)
		get_parent().tiles.set_cellv(Vector2(4,5),3)
		
		get_parent().tiles.set_cellv(Vector2(-14,0),3)
		get_parent().tiles.set_cellv(Vector2(-14,1),3)
		get_parent().tiles.set_cellv(Vector2(-13,1),3)
		get_parent().tiles.set_cellv(Vector2(-13,2),3)
		#get_parent().tiles.set_cellv(Vector2(-13,2),3)
		#get_parent().tiles.set_cellv(Vector2(-13,2),3)
		get_parent().tiles.set_cellv(Vector2(-11,3),3)
		get_parent().tiles.set_cellv(Vector2(-11,4),3)
		get_parent().tiles.set_cellv(Vector2(-10,4),3)
		get_parent().tiles.set_cellv(Vector2(-10,5),3)
		get_parent().tiles.set_cellv(Vector2(-9,5),3)
		
		get_parent().tiles.set_cellv(Vector2(-12,1),3)
		get_parent().tiles.set_cellv(Vector2(-11,1),3)
		get_parent().tiles.set_cellv(Vector2(-10,1),3)
		get_parent().tiles.set_cellv(Vector2(-9,1),3)
		
		get_parent().tiles.set_cellv(Vector2(1,1),3)
		get_parent().tiles.set_cellv(Vector2(2,1),3)
		get_parent().tiles.set_cellv(Vector2(2,0),3)
		get_parent().tiles.set_cellv(Vector2(3,0),3)
		get_parent().tiles.set_cellv(Vector2(3,-1),3)
		#get_parent().tiles.set_cellv(Vector2(3,-1),3)
		get_parent().tiles.set_cellv(Vector2(5,-2),3)
		get_parent().tiles.set_cellv(Vector2(5,-3),3)
		get_parent().tiles.set_cellv(Vector2(6,-3),3)
		get_parent().tiles.set_cellv(Vector2(4,-3),3)
		get_parent().tiles.set_cellv(Vector2(3,-3),3)
		get_parent().tiles.set_cellv(Vector2(2,-3),3)
		get_parent().tiles.set_cellv(Vector2(1,-3),3)
		get_parent().tiles.set_cellv(Vector2(6,-4),3)
		
		get_parent().tiles.set_cellv(Vector2(-9,-3),3)
		get_parent().tiles.set_cellv(Vector2(-10,-3),3)
		get_parent().tiles.set_cellv(Vector2(-11,-3),3)
		get_parent().tiles.set_cellv(Vector2(-12,-3),3)
		get_parent().tiles.set_cellv(Vector2(-13,-3),3)
		get_parent().tiles.set_cellv(Vector2(-14,-3),3)
		get_parent().tiles.set_cellv(Vector2(-14,-4),3)
		get_parent().spawnertimer.timer = 0
	
	elif selected_level == 6:
		get_parent().count_top = 6
		get_parent().bottom.bot_count = 0
		get_parent().clients.spawn_timer = 400
		get_parent().spawnertimer.basetimer = 50
		get_parent().spawnertimer.rand_extra = 50
	
		get_parent().tiles.set_cellv(Vector2(-12,9),3)
		get_parent().tiles.set_cellv(Vector2(-11,9),3)
		get_parent().tiles.set_cellv(Vector2(-10,9),3)
		get_parent().tiles.set_cellv(Vector2(-9,9),3)
		get_parent().tiles.set_cellv(Vector2(-7,9),3)
	#	get_parent().tiles.set_cellv(Vector2(-8,9),3)
		
		get_parent().tiles.set_cellv(Vector2(4,5),3)
		get_parent().tiles.set_cellv(Vector2(3,5),3)
		get_parent().tiles.set_cellv(Vector2(2,5),3)
		get_parent().tiles.set_cellv(Vector2(1,5),3)
		get_parent().tiles.set_cellv(Vector2(-1,5),3)
	#	get_parent().tiles.set_cellv(Vector2(0,5),3)
	#	get_parent().tiles.set_cellv(Vector2(-1,5),3)
		
		get_parent().tiles.set_cellv(Vector2(-12,1),3)
		get_parent().tiles.set_cellv(Vector2(-11,1),3)
		get_parent().tiles.set_cellv(Vector2(-10,1),3)
		get_parent().tiles.set_cellv(Vector2(-9,1),3)
		get_parent().tiles.set_cellv(Vector2(-7,1),3)
	#	get_parent().tiles.set_cellv(Vector2(-8,1),3)
		
		get_parent().tiles.set_cellv(Vector2(4,-3),3)
		get_parent().tiles.set_cellv(Vector2(3,-3),3)
		get_parent().tiles.set_cellv(Vector2(2,-3),3)
		get_parent().tiles.set_cellv(Vector2(1,-3),3)
		get_parent().tiles.set_cellv(Vector2(-1,-3),3)
	#	get_parent().tiles.set_cellv(Vector2(0,-3),3)
	#	get_parent().tiles.set_cellv(Vector2(-1,-3),3)
		get_parent().spawnertimer.timer = 0
	
	
	elif selected_level == 5:
		get_parent().count_top = 3
		get_parent().bottom.bot_count = 9
		get_parent().clients.spawn_timer = 550
		get_parent().spawnertimer.basetimer = 35
		get_parent().spawnertimer.rand_extra = 1
		
		shoot_ladder(Vector2(0,-16),false)
		shoot_ladder(Vector2(0,16),false)
		shoot_ladder(Vector2(0,48),false)
		shoot_ladder(Vector2(0,80),false)
		shoot_ladder(Vector2(-56,-16),false)
		shoot_ladder(Vector2(-56,16),false)
		shoot_ladder(Vector2(-56,48),false)
		shoot_ladder(Vector2(-56,80),false)
		
		get_parent().tiles.set_cellv(Vector2(4,-3),3)
		get_parent().tiles.set_cellv(Vector2(3,-3),3)
		get_parent().tiles.set_cellv(Vector2(-12,1),3)
		get_parent().tiles.set_cellv(Vector2(-11,1),3)
		get_parent().tiles.set_cellv(Vector2(4,5),3)
		get_parent().tiles.set_cellv(Vector2(3,5),3)
		get_parent().tiles.set_cellv(Vector2(-12,9),3)
		get_parent().tiles.set_cellv(Vector2(-11,9),3)
		get_parent().spawnertimer.timer = 0
	
	elif selected_level == 4:
		get_parent().count_top = 6
		get_parent().bottom.bot_count = 0
		get_parent().clients.spawn_timer = 400
		get_parent().spawnertimer.basetimer = 15
		get_parent().spawnertimer.rand_extra = 1
		
		shoot_ladder(Vector2(0,-16),false)
		shoot_ladder(Vector2(-56,16),false)
		shoot_ladder(Vector2(0,48),false)
		shoot_ladder(Vector2(-56,80),false)
		
		get_parent().tiles.set_cellv(Vector2(-14,-4),3)
		
		get_parent().tiles.set_cellv(Vector2(-14,-3),3)
		get_parent().tiles.set_cellv(Vector2(-13,-3),3)
		get_parent().tiles.set_cellv(Vector2(-12,-3),3)
		get_parent().tiles.set_cellv(Vector2(-11,-3),3)
		get_parent().tiles.set_cellv(Vector2(-10,-3),3)
		#get_parent().tiles.set_cellv(Vector2(-9,-3),3)
		
		get_parent().tiles.set_cellv(Vector2(-14,0),3)
		get_parent().tiles.set_cellv(Vector2(-14,1),3)
		get_parent().tiles.set_cellv(Vector2(-13,1),3)
		get_parent().tiles.set_cellv(Vector2(-12,1),3)
		get_parent().tiles.set_cellv(Vector2(-11,1),3)
		get_parent().tiles.set_cellv(Vector2(-10,1),3)
		get_parent().tiles.set_cellv(Vector2(-9,1),3)
		get_parent().tiles.set_cellv(Vector2(-10,1),3)
		get_parent().tiles.set_cellv(Vector2(-14,2),3)
		get_parent().tiles.set_cellv(Vector2(-13,2),3)
		get_parent().tiles.set_cellv(Vector2(-12,2),3)
		get_parent().tiles.set_cellv(Vector2(-12,3),3)
		#get_parent().tiles.set_cellv(Vector2(-9,-3),3)
		
		get_parent().tiles.set_cellv(Vector2(1,5),3)
		get_parent().tiles.set_cellv(Vector2(2,5),3)
		get_parent().tiles.set_cellv(Vector2(3,5),3)
		get_parent().tiles.set_cellv(Vector2(4,5),3)
		get_parent().tiles.set_cellv(Vector2(6,4),3)
		get_parent().tiles.set_cellv(Vector2(6,5),3)
		get_parent().tiles.set_cellv(Vector2(5,5),3)
		get_parent().tiles.set_cellv(Vector2(5,6),3)
		get_parent().tiles.set_cellv(Vector2(4,6),3)
		get_parent().tiles.set_cellv(Vector2(4,7),3)
		
		get_parent().tiles.set_cellv(Vector2(1,-3),3)
		get_parent().tiles.set_cellv(Vector2(2,-3),3)
		get_parent().tiles.set_cellv(Vector2(3,-3),3)
		get_parent().tiles.set_cellv(Vector2(4,-3),3)
		get_parent().tiles.set_cellv(Vector2(6,-4),3)
		get_parent().tiles.set_cellv(Vector2(6,-3),3)
		get_parent().tiles.set_cellv(Vector2(5,-3),3)
		get_parent().tiles.set_cellv(Vector2(5,-2),3)
		get_parent().tiles.set_cellv(Vector2(4,-2),3)
		get_parent().tiles.set_cellv(Vector2(4,-1),3)
		
		get_parent().tiles.set_cellv(Vector2(-12,9),3)
		get_parent().tiles.set_cellv(Vector2(-11,9),3)
		get_parent().tiles.set_cellv(Vector2(-10,9),3)
		get_parent().tiles.set_cellv(Vector2(-9,9),3)
		get_parent().spawnertimer.timer = 0
	
	
	elif selected_level == 3:
		get_parent().count_top = 3
		get_parent().bottom.bot_count = 3
		get_parent().clients.spawn_timer = 300
		get_parent().spawnertimer.basetimer = 300
		get_parent().spawnertimer.rand_extra = 1
		
		shoot_ladder(Vector2(0,16),false)
		shoot_ladder(Vector2(-56,48),true)
		shoot_ladder(Vector2(0,80),false)
		shoot_ladder(Vector2(-56,-16),false)
		get_parent().spawnertimer.timer = 0
	
	
	elif selected_level == 2:
		get_parent().count_top = 0
		get_parent().bottom.bot_count = 3
		get_parent().clients.spawn_timer = 250
		get_parent().spawnertimer.basetimer = 500
		get_parent().spawnertimer.rand_extra = 1
		
		shoot_ladder(Vector2(-48,16),true)
		shoot_ladder(Vector2(-8,16),true)
		shoot_ladder(Vector2(-40,48),true)
		shoot_ladder(Vector2(-16,48),true)
		shoot_ladder(Vector2(-48,80),true)
		shoot_ladder(Vector2(-8,80),true)
		shoot_ladder(Vector2(-40,-16),true)
		shoot_ladder(Vector2(-16,-16),true)
		
		get_parent().tiles.set_cellv(Vector2(-12,9),3)
		get_parent().tiles.set_cellv(Vector2(-11,9),3)
		get_parent().tiles.set_cellv(Vector2(-10,9),3)
		#get_parent().tiles.set_cellv(Vector2(-9,9),3)
		#get_parent().tiles.set_cellv(Vector2(-8,9),3)
		
		get_parent().tiles.set_cellv(Vector2(4,5),3)
		get_parent().tiles.set_cellv(Vector2(3,5),3)
		get_parent().tiles.set_cellv(Vector2(2,5),3)
		#get_parent().tiles.set_cellv(Vector2(1,5),3)
		#get_parent().tiles.set_cellv(Vector2(0,5),3)
		#get_parent().tiles.set_cellv(Vector2(-1,5),3)
		
		get_parent().tiles.set_cellv(Vector2(-12,1),3)
		get_parent().tiles.set_cellv(Vector2(-11,1),3)
		get_parent().tiles.set_cellv(Vector2(-10,1),3)
		#get_parent().tiles.set_cellv(Vector2(-9,1),3)
		#get_parent().tiles.set_cellv(Vector2(-8,1),3)
		
		get_parent().tiles.set_cellv(Vector2(4,-3),3)
		get_parent().tiles.set_cellv(Vector2(3,-3),3)
		get_parent().tiles.set_cellv(Vector2(2,-3),3)
		#get_parent().tiles.set_cellv(Vector2(1,-3),3)
		#get_parent().tiles.set_cellv(Vector2(0,-3),3)
		#get_parent().tiles.set_cellv(Vector2(-1,-3),3)
		
		get_parent().tiles.set_cellv(Vector2(-14,-4),3)
		
		get_parent().tiles.set_cellv(Vector2(-14,-3),3)
		get_parent().tiles.set_cellv(Vector2(-13,-3),3)
		get_parent().tiles.set_cellv(Vector2(-12,-3),3)
		get_parent().tiles.set_cellv(Vector2(-11,-3),3)
		get_parent().tiles.set_cellv(Vector2(-10,-3),3)
		#get_parent().tiles.set_cellv(Vector2(-9,-3),3)
		get_parent().spawnertimer.timer = 0
	
	
	elif selected_level == 1:
		get_parent().count_top = 3
		get_parent().bottom.bot_count = 0
		get_parent().spawn_limit = 9
		get_parent().clients.spawn_timer = 300
		get_parent().spawnertimer.basetimer = 500
		get_parent().spawnertimer.rand_extra = 1
		shoot_ladder(Vector2(0,16),false)
		shoot_ladder(Vector2(0,80),false)
		get_parent().spawnertimer.timer = 0
	
	
	else:#if level != 9990:
		get_parent().count_top = 9
		get_parent().spawn_limit = 9
		get_parent().bottom.bot_count = 9
		get_parent().spawnertimer.basetimer = 250
		get_parent().spawnertimer.rand_extra = 250
	
	
	#get_parent().spawnertimer.timer = get_parent().spawnertimer.basetimer
	
	
	
	








func not_zero(x):
	if x == 0: x = 1
	return x



var ladder = preload("res://objects/arcades/OpenBar/OPladder.tscn")

func shoot_ladder(pos,x):
	var inst = ladder.instance()
	inst.position = pos
	inst.broken = x
	
	get_parent().BG.add_child(inst)
