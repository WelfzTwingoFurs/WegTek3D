extends Node2D

export var be_player = false
var map_on = false

var hudbot = "  LVL3  -  HISCORE:123.456.789  "
var hudtop = " MEN:^^^^^+3 SCORE:123.456.789 "

var score = 0
var hiscore = 123456789
var lives = 15
var toptimer = 50
var topstring = "WELCOME, NOW... BE A JERK!"
var combo = 1
var ammo = 3

func _physics_process(_delta):
	if toptimer > 0:
		toptimer -= 1

func _process(_delta):
	if toptimer < 1:
		combo = 1
		hudtop = "MEN:"
		
		if lives >= 15: lives = 14
		for n in lives:
			hudtop += "^"
			if n > 6:
				hudtop.erase(hudtop.length()-3, 2)
				hudtop += str("+",lives-n+2)
				break
		
		hudtop += " SCORE:"
		#for n in str(score).length():
		for n in 9-str(score).length():
			hudtop += str(0)
		
		hudtop += str(score)
		hudtop = hudtop.insert(hudtop.length()-3,".")
		hudtop = hudtop.insert(hudtop.length()-7,".")
		
		$BG/Labeltop.text = hudtop
	else:
		$BG/Labeltop.text = topstring
	
	
	hudbot = "GUN:########## TOP:"
	for n in 9-str(hiscore).length():
		hudbot += str(0)
	
	hudbot += str(hiscore)
	hudbot = hudbot.insert(hudbot.length()-3,".")
	hudbot = hudbot.insert(hudbot.length()-7,".")
	$BG/Labelbot.text = hudbot


func _ready():
	update()
	if be_player: Worldconfig.player = self
