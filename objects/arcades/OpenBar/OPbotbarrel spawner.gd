extends Node2D

export var on = false

var timer = 0
export var basetimer = 100
export var rand_extra = 20

var lock = false

func _physics_process(_delta):
	if on:
		if (get_parent().get_parent().player.position.y > 73):
			lock = true
		else:
			lock = false
		
		
		if (get_parent().get_parent().bottom.bot_count > 0) && !lock:
			timer -= 1
			if timer < 1:
				get_parent().get_parent().bottom.bot_count -= 1
				shoot()
				timer = basetimer +(randi() % rand_extra) -(randi() % rand_extra)

var barrel = preload("res://objects/arcades/OpenBar/OPbarrelfoe.tscn")

var spawncounter = 0

func shoot():
	var inst = barrel.instance()
	inst.position = Vector2(49,104)
	inst.inputX = -1
	inst.goingup = true
	get_parent().add_child(inst)
