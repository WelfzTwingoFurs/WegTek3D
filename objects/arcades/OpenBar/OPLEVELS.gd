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
		
	
	if level == 0: nextlevel()
	elif get_parent().total_barrels == 0:
		$AniPlay.play("next")

func buildlevel():
	for n in 28:#how many verical tiles
		for m in 32:
			#default_tiles.push_back(get_parent().tiles.get_cell(m-16,n-14))
			get_parent().tiles.set_cellv(Vector2(m-16,n-14), default_tiles[(n*32)+m])


func unload():
	get_parent().queue_current = 0
	get_parent().barrelshand = 0
	get_parent().clients.spawncounter = 0
	get_parent().mug.frame = 0
	get_parent().outdoor.frame = 4
	for n in get_parent().clients.get_children():
		n.queue_free()
	
	for n in get_parent().BG.get_children():
		if n.is_in_group("OPfoe"):
			n.queue_free()
	
	for n in get_parent().BG.get_children():
		if n.is_in_group("OPladder"):
			n.queue_free()


func reload():
	get_parent().lives += 1
	get_parent().audio_triangle.stop()
	get_parent().audio_triangle.play()
	unload()
	loadlevel()

func nextlevel():
	level +=1
	get_parent().audio_triangle.radio()
	loadlevel()

func loadlevel():
	buildlevel()
	
	get_parent().outdoor.frame = 0
	get_parent().player.jumped = true
	get_parent().player.ladderbusy = true
	get_parent().player.falldist = 103
	get_parent().player.position = Vector2(57,103)
	get_parent().player.dead = false
	get_parent().player.ladderbusy = false
	
	
	
	#level = 2
	
	if level == 1:
		get_parent().count_top = 6
		get_parent().spawn_limit = 9
		get_parent().bottom.bot_count = 0
		get_parent().spawnertimer.basetimer = 375
		get_parent().spawnertimer.rand_extra = 10
		shoot_ladder(Vector2(0,16),false)
		shoot_ladder(Vector2(0,80),false)
		
	
	
	elif level == 2:
		get_parent().count_top = 0
		get_parent().spawn_limit = 8
		get_parent().bottom.bot_count = 3
		get_parent().spawnertimer.basetimer = 375
		get_parent().spawnertimer.rand_extra = 10
		
		shoot_ladder(Vector2(-32,16),false)
		shoot_ladder(Vector2(-24,48),false)
		shoot_ladder(Vector2(-32,80),false)
		shoot_ladder(Vector2(-24,-16),false)
		
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
	
	
	
	elif level == 3:
		get_parent().count_top = 6
		get_parent().spawn_limit = 7
		get_parent().bottom.bot_count = 0#3
		get_parent().spawnertimer.basetimer = 375
		get_parent().spawnertimer.rand_extra = 10
		shoot_ladder(Vector2(0,16),false)
		shoot_ladder(Vector2(-56,48),true)
		shoot_ladder(Vector2(0,80),false)
		shoot_ladder(Vector2(-56,-16),false)
	
	else:#if level != 9990:
		get_parent().count_top = level
		get_parent().spawn_limit = 9-level
		get_parent().bottom.bot_count = level
		get_parent().spawnertimer.basetimer = 375-(level*10)
		get_parent().spawnertimer.rand_extra = 10*level

func not_zero(x):
	if x == 0: x = 1
	return x



var ladder = preload("res://objects/arcades/OpenBar/OPladder.tscn")

func shoot_ladder(pos,x):
	var inst = ladder.instance()
	inst.position = pos
	inst.broken = x
	
	get_parent().BG.add_child(inst)
