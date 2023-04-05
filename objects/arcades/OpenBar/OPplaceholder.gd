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
		get_parent().get_parent().audio_square2.gate()
		player.dead = true
		outdoor.frame = 3
		$BG/getbarrel.bot_count = 0

func _ready():
	organize_scores()
	
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


export var lives = 0
var score = 0
#var highscore = 123456
#var initials = "ABC"

#var tablescores = ["DUQ999999","NAT999998","LOK999988","JAC999888","SAM998888"]
#var tablescores = ["DUQ000001","NAT000002","LOK000003","JAC000004","SAM000005"]
#var tablescores = ["DUQ024000","NAT003621","LOK006900","JAC000666","SAM000420"]
var tablescores = ["DUQ024000","NAT003621","LOK006900","JAC000666","SAM000001"]
var new_letters = "---"
var current_letter = 0
var current_letter_id = 0

export var game_on = false
export var over = false

func _process(_delta):
	if score > 999999:
		score = 999999
	if lives > 99:
		lives = 99
	
	if Input.is_action_just_pressed("arc_coin"):
		lives += 1
	
	if !game_on:
		BG.visible = false
		$Gameoff.visible = true
		levels.gameoff()
		
		if over:
			score = int(score)
			
			$Gameoff.frame = 2
			
			organize_scores()
			
			
			var coolstring = "\n\n\n\n\n\n"
			for n in 5:
				#coolstring+= "         A.B.C. 123,456\n\n"
				coolstring+= str("        ",n+1,"-")
				coolstring+= tablescores[n].substr(0,1)
				coolstring+= "."
				coolstring+= tablescores[n].substr(1,1)
				coolstring+= "."
				coolstring+= tablescores[n].substr(2,1)
				coolstring+= ". "
				
				#NUMBERS
				for m in 6-str(int(tablescores[n].substr(3,6))).length():
					coolstring+= " "
					if m == 2:
						coolstring+= " "
				
				if str(int(tablescores[n].substr(3,6))).length() > 3:
					coolstring+= str(int(tablescores[n].substr(3,3)))
					coolstring+= ","
					coolstring+= str((tablescores[n].substr(6,3)))
				else:
					coolstring+= str(int(tablescores[n].substr(6,3)))
				
				#coolstring+= str(int(tablescores[n].substr(3,6)))
				coolstring+= "\n\n"
				
			
			if (current_letter < 3):
			
				for n in 5:
					if score > int(tablescores[n].substr(3,6)):
						#coolstring += "\n\n\n\n\n         -.-.-. "
						coolstring += str("\n\n\n\n\n         ",new_letters.substr(0,1),".",new_letters.substr(1,1),".",new_letters.substr(2,1),". ")
						if !audio_square2.is_playing(): audio_square2.win_song()
						break
					elif n == 4:
						if !audio_square2.is_playing() && (audio_square2.stream != audio_square2.over): audio_square2.gameover()
						coolstring += "\n\n\n\n\n         SORRY! "
						current_letter = 2
						if Input.is_action_just_pressed("arc_button1") or ((audio_square2.stream == audio_square2.over) && !audio_square2.is_playing()):
							current_letter = 0
							current_letter_id = 0
							new_letters = "---"
							score = 0
							audio_square2.stop()
							audio_square2.sfx_jumpscore()
							over = false
				
				
				for m in 6-str(score).length():
					coolstring+= " "
					if m == 2:
						coolstring+= " "
				
				if str(score).length() > 3:
					if str(score).length() == 4:
						coolstring += str(str(score).substr(0,1),",",str(score).substr(1))
					elif str(score).length() == 5:
						coolstring += str(str(score).substr(0,2),",",str(score).substr(2))
					else:
						coolstring += str(str(score).substr(0,3),",",str(score).substr(3))
				else:
					coolstring += str(score)
			
			#coolstring += "\n\n\n\n\n         A.B.C. 123,456"
			$Gameoff/Label2.text = coolstring
			
			#while new_letters.substr(0,1) == "-":
			#	print("fuck")
			
			if Input.is_action_just_pressed("arc_up"):
				current_letter_id += 1
				if current_letter_id > 36: current_letter_id = 0
			elif Input.is_action_just_pressed("arc_down"):
				current_letter_id -= 1
				if current_letter_id < 0: current_letter_id = 36
			elif Input.is_action_just_pressed("arc_button1"):
				current_letter += 1
			
			if current_letter == 3:
				coolstring = str(new_letters)
				for n in 6-str(score).length():
					coolstring += "0"
				coolstring += str(score)
				tablescores.push_back(coolstring)
				organize_scores()
				audio_square2.gameover()
				current_letter += 1
			
			
			
			
			
			
			elif current_letter < 3:
				if current_letter_id == 0:
					new_letters[current_letter] = "A"
				elif current_letter_id == 1:
					new_letters[current_letter] = "B"
				elif current_letter_id == 2:
					new_letters[current_letter] = "C"
				elif current_letter_id == 3:
					new_letters[current_letter]= "D"
				elif current_letter_id == 4:
					new_letters[current_letter] = "E"
				elif current_letter_id == 5:
					new_letters[current_letter] = "F"
				elif current_letter_id == 6:
					new_letters[current_letter] = "G"
				elif current_letter_id == 7:
					new_letters[current_letter] = "H"
				elif current_letter_id == 8:
					new_letters[current_letter] = "I"
				elif current_letter_id == 9:
					new_letters[current_letter] = "J"
				elif current_letter_id == 10:
					new_letters[current_letter] = "K"
				elif current_letter_id == 11:
					new_letters[current_letter] = "L"
				elif current_letter_id == 12:
					new_letters[current_letter] = "M"
				elif current_letter_id == 13:
					new_letters[current_letter] = "N"
				elif current_letter_id == 14:
					new_letters[current_letter] = "O"
				elif current_letter_id == 15:
					new_letters[current_letter] = "P"
				elif current_letter_id == 16:
					new_letters[current_letter] = "Q"
				elif current_letter_id == 17:
					new_letters[current_letter] = "R"
				elif current_letter_id == 18:
					new_letters[current_letter] = "S"
				elif current_letter_id == 19:
					new_letters[current_letter] = "T"
				elif current_letter_id == 20:
					new_letters[current_letter] = "U"
				elif current_letter_id == 21:
					new_letters[current_letter] = "V"
				elif current_letter_id == 22:
					new_letters[current_letter] = "W"
				elif current_letter_id == 23:
					new_letters[current_letter] = "X"
				elif current_letter_id == 24:
					new_letters[current_letter] = "Y"
				elif current_letter_id == 25:
					new_letters[current_letter] = "Z"
				elif current_letter_id == 26:
					new_letters[current_letter] = "0"
				elif current_letter_id == 27:
					new_letters[current_letter] = "1"
				elif current_letter_id == 28:
					new_letters[current_letter] = "2"
				elif current_letter_id == 29:
					new_letters[current_letter] = "3"
				elif current_letter_id == 30:
					new_letters[current_letter] = "4"
				elif current_letter_id == 31:
					new_letters[current_letter] = "5"
				elif current_letter_id == 32:
					new_letters[current_letter] = "6"
				elif current_letter_id == 33:
					new_letters[current_letter] = "7"
				elif current_letter_id == 34:
					new_letters[current_letter] = "8"
				elif current_letter_id == 35:
					new_letters[current_letter] = "9"
				elif current_letter_id == 36:
					new_letters[current_letter] = " "
			
			
			if (current_letter > 2) && ((audio_square2.stream == audio_square2.over) && !audio_square2.is_playing()):
				current_letter = 0
				current_letter_id = 0
				new_letters = "---"
				score = 0
				audio_square2.stop()
				audio_square2.sfx_jumpscore()
				over = false
			elif current_letter > 2:
				$Gameoff/Label2.text += str("\n          BYE-BYE ",removed,"!")
				if Input.is_action_just_pressed("arc_coin"):
					audio_square2.stop()
			
			
			
			
		else:
			$Gameoff.frame = 1
			#var coolstring = str("\n      HISCORE -ORE- ,",highscore,"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n       PUSH JUMP! ",lives," LIVES")
			var coolstring = str("\n      HISCORE -",tablescores[0].substr(0,3),"- ",tablescores[0].substr(3,6),"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
			
			if lives > 0:
				coolstring += "\n        PUSH JUMP!"
				if str(lives+1).length() == 2:
					coolstring += str(lives+1," MEN")
				else:
					coolstring += str(" ",lives+1," MEN")
				
				if Input.is_action_just_pressed("arc_button1"):
					levels.start()
					game_on = true
			else:
				#coolstring += "        1 COIN IS 1 LIFE"
				coolstring += "        1ST COIN - 2 MEN\n"
				coolstring += "\n         + COINS - 1 MAN"
		
			$Gameoff/Label2.text = coolstring
		
	else:
		$Gameoff.visible = false
		BG.visible = true
	
	
		if was_queue != queue:
			for n in $"BG/client-spawner".get_children():
				n.queue_position -= 1
			$"BG/client-spawner".spawncounter -= 1
			was_queue = queue
		
		
		
		
		
		var coolstring = str("ADOLFO\n")
		
		for n in 6-str(int(score)).length():
			coolstring += " "
		
		#if str(int(score)).length() > 6:
		
		coolstring += str(int(score),"\n")
		
		
		
		for n in lives:
			coolstring += "^"
			if n == 5: coolstring += "\n"
			elif n == 11:
				lives = 12
				break
		
		if lives <= 5: coolstring += "\n"
		
		for n in 12-lives:
			coolstring += " "
		
		var FUCK = 0
		for n in $BG.get_children():
			if n.is_in_group("OPfoe"):
				FUCK += 1
		
		
		total_barrels = count_top+$BG/getbarrel.bot_count+barrelshand+FUCK
		
		#coolstring += str("\n %",not_minus(queue_current),"/",spawn_limit,"\n #*",count_top+$BG/getbarrel.bot_count+barrelshand+FUCK,"\n< ",delitimer,"\n\n\nHI DKC\n123456")
		#coolstring += str("\n %",not_minus(queue_current),"/",spawn_limit,"\n #*")
		coolstring += str("\n %",not_minus(queue_current),"/9\n #*")
		
		if total_barrels < 9: coolstring += str(0)
		coolstring += str(total_barrels,"\n\nDAY ")
		
		
		if str(levels.level).length() < 2:
			coolstring += str(0)
			
		coolstring += str(levels.level,"\n")
		
		for n in 6-str(int(score)).length():
			coolstring += " "
		coolstring += str("\nHI ",tablescores[0].substr(0,3),"\n",tablescores[0].substr(3,6))
		
	#	if (delitimer/60) > 60:
	#		coolstring += str((delitimer/60)/60,"=")
	#		if ((delitimer/60)-(60*((delitimer/60)/60))) < 10: coolstring += str(0)
	#		coolstring += str((delitimer/60)-(60*((delitimer/60)/60)))
	#	else:
	#		coolstring += str("0=")
	#		if ((delitimer/60)-(60*((delitimer/60)/60))) < 10: coolstring += str(0)
	#		coolstring += str((delitimer/60)-(60*((delitimer/60)/60)))
		
		$BG/Label.text = coolstring
		







var removed = ""

func organize_scores():
	if tablescores.size() > 5:
		for n in 6:
			if n > 1:
				if int(tablescores[n].substr(3,6)) > int(tablescores[n-1].substr(3,6)):
					for m in n:
						if int(tablescores[n-m].substr(3,6)) > int(tablescores[n-m-1].substr(3,6)):
							var temp = tablescores[n-m]
							tablescores[n-m] = tablescores[n-m-1]
							tablescores[n-m-1] = temp
		removed = tablescores[5].substr(0,3)
		tablescores.erase(tablescores[5])
	
	
	for n in 5:
		if n > 1:
			if int(tablescores[n].substr(3,6)) > int(tablescores[n-1].substr(3,6)):
				for m in n:
					if int(tablescores[n-m].substr(3,6)) > int(tablescores[n-m-1].substr(3,6)):
						var temp = tablescores[n-m]
						tablescores[n-m] = tablescores[n-m-1]
						tablescores[n-m-1] = temp
















func not_minus(x):
	if x < 0: x = 0
	return x
