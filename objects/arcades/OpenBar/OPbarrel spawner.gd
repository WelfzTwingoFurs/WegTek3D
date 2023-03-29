extends Node2D


var timer = 0
export var basetimer = 100
export var rand_extra = 20

var lock = false

func _physics_process(_delta):
	if (get_parent().get_parent().player.position.x < -40):
		if (get_parent().get_parent().player.position.y < -23):
			lock = true
		else:
			lock = false
	else:
		lock = false
	
	
	if (get_parent().get_parent().count_top > 0) && !lock:
		timer -= 1
		if timer < 1:
			get_parent().get_parent().count_top -= 1
			shoot()
			timer = basetimer +(randi() % rand_extra) -(randi() % rand_extra)

var barrel = preload("res://objects/arcades/OpenBar/OPbarrelfoe.tscn")

var spawncounter = 0

func shoot():
	var inst = barrel.instance()
	inst.position = Vector2(-96,-54)
	get_parent().add_child(inst)
