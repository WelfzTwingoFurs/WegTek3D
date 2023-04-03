extends Node2D

var map_on = false
var be_player = true


var total_barrels = 0

var barrelsbot = []
var barrelstop = []
var barrelshand = 0
export var count_top = 4
onready var bottom = $BG/getbarrel
onready var spawnertimer = $"BG/topbarrel spawner"
onready var BG = $BG
onready var clients = $"BG/client-spawner"
export var spawn_limit = 5

onready var player = $BG/player
onready var mug = $BG/mug
onready var outdoor = $BG/sign
onready var audio_triangle = $AudioTriangle
onready var audio_square1 = $AudioSquare1
onready var audio_square2 = $AudioSquare2
onready var audio_noise = $AudioNoise
onready var tiles = $BG/OPtileCol
onready var levels = $LEVELS

var queue = 0
var was_queue = 0
var queue_current = 0

#var delitimer = 5450
#
#func _physics_process(_delta):
#	if !player.dead && bottom.bot_count:
#		delitimer -= 1
#		if delitimer < 0:
#			delitimer = 5450

func deliver():
	$BG/getbarrel.bot_count += 7
	if $BG/getbarrel.bot_count > 9:
		player.dead = true
		outdoor.frame = 3
		$BG/getbarrel.bot_count = 0

func _ready():
	for n in $"BG/barrels bot".get_children():
		barrelsbot.push_front(n)
	
	for n in $"BG/barrels top".get_children():
		barrelstop.push_front(n)
	
	#update()
	if be_player:
		Worldconfig.player = self
		Worldconfig.Camera2D = $Camera2D
		if !Input.is_action_pressed("bug_reset"): 
			OS.set_window_maximized(true)
			Worldconfig.zoom = 4
			Worldconfig.config = 0
			Worldconfig.step = 1


export var lives = 12
var score = 0

func _process(_delta):
#	if count_top+$BG/getbarrel.bot_count <= 0:
#		delitimer = 0
	
	
	
	if was_queue != queue:
		for n in $"BG/client-spawner".get_children():
			n.queue_position -= 1
		$"BG/client-spawner".spawncounter -= 1
		was_queue = queue
	
	
	
	
	
	var coolstring = str("ADOLFO\n")
	
	for n in 6-str(int(score)).length():
		coolstring += " "
	
	if str(int(score)).length() > 6:
		score = 999999
	
	coolstring += str(int(score),"\n")
	
	
	
	for n in lives:
		coolstring += "^"
		if n == 5: coolstring += "\n"
		elif n == 11:
			lives = 12
			break
	
	if lives < 5: coolstring += "\n"
	
	for n in 12-lives:
		coolstring += " "
	
	var FUCK = 0
	for n in $BG.get_children():
		if n.is_in_group("OPfoe"):
			FUCK += 1
	
	
	total_barrels = count_top+$BG/getbarrel.bot_count+barrelshand+FUCK
	
	#coolstring += str("\n %",not_minus(queue_current),"/",spawn_limit,"\n #*",count_top+$BG/getbarrel.bot_count+barrelshand+FUCK,"\n< ",delitimer,"\n\n\nHI DKC\n123456")
	coolstring += str("\n %",not_minus(queue_current),"/",spawn_limit,"\n #*")
	
	if total_barrels < 9: coolstring += str(0)
	coolstring += str(total_barrels,"\n\nWAVE")
	
	
	if str(levels.level).length() < 2:
		coolstring += str(0)
		
	coolstring += str(levels.level)
	
#	if (delitimer/60) > 60:
#		coolstring += str((delitimer/60)/60,"=")
#		if ((delitimer/60)-(60*((delitimer/60)/60))) < 10: coolstring += str(0)
#		coolstring += str((delitimer/60)-(60*((delitimer/60)/60)))
#	else:
#		coolstring += str("0=")
#		if ((delitimer/60)-(60*((delitimer/60)/60))) < 10: coolstring += str(0)
#		coolstring += str((delitimer/60)-(60*((delitimer/60)/60)))
	
	$BG/Label.text = coolstring
	


func not_minus(x):
	if x < 0: x = 0
	return x
