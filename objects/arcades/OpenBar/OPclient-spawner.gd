extends Node2D

var man = preload("res://objects/arcades/OpenBar/OPclient.tscn")

var spawncounter = 0

func shoot():
	var inst = man.instance()
	inst.skin = randi() % 5
	inst.queue_position = spawncounter
	add_child(inst)
	spawncounter += 1
	
	if spawncounter > get_parent().get_parent().spawn_limit:
		get_parent().get_parent().player.dead = true

var timer = 10

func _physics_process(_delta):
	if !get_parent().get_parent().player.dead:
		timer -= 1
		if timer == 0:
			shoot()
			timer = 500
