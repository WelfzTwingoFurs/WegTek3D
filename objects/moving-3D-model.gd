extends Node2D

export var scaleZ = 1
var extraZ

func _ready():
	scaleZ = get_parent().scaleZ
	
	for n in get_children():
		for m in n.heights.size():
			n.heights[m] *= scaleZ

func _process(_delta):
	for n in get_children():
		for m in n.extraZ.size():
			n.extraZ[m] = extraZ
