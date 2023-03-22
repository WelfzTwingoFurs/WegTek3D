extends Node2D

export(Array,String) var chunks = []

func _ready():
	for n in chunks.size():
		var inst = load(chunks[n])
		add_child(inst.instance())
