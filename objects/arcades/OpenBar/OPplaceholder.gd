extends Node2D

var map_on = false
var be_player = true

var barrelsbot = []
var barrelstop = []
var barrelshand = 0
export var count_top = 4
export var spawn_limit = 5

onready var player = $objects/player
onready var mug = $BG/mug
onready var outdoor = $BG/sign

var queue = 0
var was_queue = 0
var queue_current = 0


func _ready():
	for n in $"BG/barrels bot".get_children():
		barrelsbot.push_front(n)
	
	for n in $"BG/barrels top".get_children():
		barrelstop.push_front(n)
	
	#update()
	if be_player:
		Worldconfig.player = self
		Worldconfig.Camera2D = $Camera2D
		OS.set_window_maximized(true)
		Worldconfig.zoom = 4
		Worldconfig.config = 0
		Worldconfig.step = 1


func _process(_delta):
	if was_queue != queue:
		for n in $"BG/client-spawner".get_children():
			n.queue_position -= 1
		$"BG/client-spawner".spawncounter -= 1
		was_queue = queue
