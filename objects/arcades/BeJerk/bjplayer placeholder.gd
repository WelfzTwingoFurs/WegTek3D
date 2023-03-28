extends Node2D

var game_on = false

export var be_player = false
var map_on = false

var hudbot = "  LVL3  -  HISCORE:123.456.789  "
var hudtop = " MEN:^^^^^+3 SCORE:123.456.789 "

var score = 0
var lives = 0
var toptimer = 1
var topstring = "INSERT COIN"
var combo = 1
var ammo = 0

var tempo = 2000

func _physics_process(_delta):
	if game_on:
		if toptimer > 0:
			toptimer -= 1
		
		if tempo > 0:
			tempo -= 1


var initials = ["WFZ","CAP","COM","JOE"]
var scores = [123456789,12345678,1234567,123456]

func _process(_delta):
	if Input.is_action_just_pressed("ply_yes"):
		lives += 1
	
	if lives > 21: lives = 21
	if !game_on:
		if lives == 0:
			$BG/Labeltop.text = "INSERT A COIN, 1 COIN = 1 LIFE"
			
			$BG/Labelside.text  = "                                "
			$BG/Labelside2.text = "                                "
			$BG/Labelside3.text = "                                "
			$BG/Labelside4.text = "                                "
			
			$BG/Labelbot.text = str("^ HISCORE [",initials[0],"]: ")
			for n in 9-str(scores[0]).length():
				$BG/Labelside4.text += str(0)
			
			$BG/Labelbot.text += str(scores[0])
			$BG/Labelbot.text = $BG/Labelbot.text.insert($BG/Labelbot.text.length()-3,".")
			$BG/Labelbot.text = $BG/Labelbot.text.insert($BG/Labelbot.text.length()-7,".")
			$BG/Labelbot.text += " ^"
			
		else:
			$BG/Labeltop.text = "THANK YOU!CREDIT:"
			if lives < 14:
				for n in lives:
					$BG/Labeltop.text += "^"
			else:
				$BG/Labeltop.text += str("^^^^^^^^^^^+",lives-11)
			
			$BG/Labelside.text  = "P                              F"
			$BG/Labelside2.text = "U                              I"
			$BG/Labelside3.text = "S                              R"
			$BG/Labelside4.text = "H                              E"
			
			$BG/Labelbot.text = "COPY,ALRIGHT?  CRACKJOGOS-2023"
			
			if Input.is_action_pressed("ply_jump"):
				toptimer = 150
				#topstring = "PLAYER START,ENJOY YOUR PLAY!^"
				topstring = "*** GAME ON! CAUSE MAYHEM! ***"
				game_on = true
		
		
	else:#if game_on:
		if tempo > 999:
			$BG/Labelside.text  = str(str(tempo)[0],"                              ",str(tempo)[0])
			$BG/Labelside2.text = str(str(tempo)[1],"                              ",str(tempo)[1])
			$BG/Labelside3.text = str(str(tempo)[2],"                              ",str(tempo)[2])
			$BG/Labelside4.text = str(str(tempo)[3],"                              ",str(tempo)[3])
		elif tempo > 99:
			$BG/Labelside.text  = str(0,"                              ",0)
			$BG/Labelside2.text = str(str(tempo)[0],"                              ",str(tempo)[0])
			$BG/Labelside3.text = str(str(tempo)[1],"                              ",str(tempo)[1])
			$BG/Labelside4.text = str(str(tempo)[2],"                              ",str(tempo)[2])
		elif tempo > 9:
			$BG/Labelside2.text = str(0,"                              ",0)
			$BG/Labelside3.text = str(str(tempo)[0],"                              ",str(tempo)[0])
			$BG/Labelside4.text = str(str(tempo)[1],"                              ",str(tempo)[1])
		else:
			$BG/Labelside3.text = str(0,"                              ",0)
			$BG/Labelside4.text = str(str(tempo)[0],"                              ",str(tempo)[0])
		
		if toptimer < 1:
			combo = 1
			hudtop = ""
			
			
			
			for n in lives:
				hudtop += "^"
				if n > 13:
					hudtop.erase(hudtop.length()-3, 3)
					hudtop += str("+",lives-n+2)
					break
			
			for n in 14-hudtop.length():
				hudtop += " "
			
			hudtop += " TOP:"
			#for n in str(score).length():
			for n in 9-str(scores[0]).length():
				hudtop += str(0)
			
			hudtop += str(scores[0])
			hudtop = hudtop.insert(hudtop.length()-3,".")
			hudtop = hudtop.insert(hudtop.length()-7,".")
			
			$BG/Labeltop.text = hudtop
		else:
			if combo > 1: $BG/Labeltop.text = str("[*",combo,"]",topstring)
			else: $BG/Labeltop.text = topstring
		
		
		if ammo > 18: ammo = 18
		hudbot = ""
		
		for n in ammo:
			hudbot += "#"
		
		for n in (19-hudbot.length()):
			hudbot += " "
		
		for n in 9-str(score).length():
			hudbot += str(0)
		
		hudbot += str(score)
		hudbot = hudbot.insert(hudbot.length()-3,".")
		hudbot = hudbot.insert(hudbot.length()-7,".")
		$BG/Labelbot.text = hudbot


func _ready():
	update()
	if be_player: Worldconfig.player = self
