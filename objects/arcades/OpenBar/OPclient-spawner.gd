extends Node2D

var man = preload("res://objects/arcades/OpenBar/OPclient.tscn")

var spawncounter = 0
export var spawn_timer = 500

func shoot():
	var inst = man.instance()
	inst.skin = randi() % 27
	inst.queue_position = spawncounter
	add_child(inst)
	spawncounter += 1
	
	if spawncounter > get_parent().get_parent().spawn_limit:
		get_parent().get_parent().audio_square2.truck()
		get_parent().get_parent().player.dead = true
		get_parent().get_parent().outdoor.frame = 2

var timer = 10

func _physics_process(_delta):
	if !get_parent().get_parent().player.dead:
		timer -= 1
		if timer == 0:
			shoot()
			timer = spawn_timer 
		
		#elif (spawncounter == 0) && get_parent().get_parent().mug.frame == 5:
		#elif (get_parent().get_parent().mug.frame == 6) && (get_parent().get_parent().queue_current == 0):
		#	shoot()
		
		#print(get_parent().get_parent().queue_current)
