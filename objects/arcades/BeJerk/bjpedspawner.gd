extends Node2D

var targets = []
var old_targets = []
const shot = preload("res://objects/arcades/BeJerk/bjped.tscn")

func _ready():
	for n in get_tree().get_nodes_in_group("entry"):
		targets.push_back(n)
	
	for n in ((randi() % 5)+1):
		var instance = shot.instance()
		var rando = 0
		while old_targets.has(rando):
			rando = randi() % targets.size()
		instance.position = targets[rando].position
		old_targets.push_back(rando)
		get_parent().call_deferred("add_child",instance)
