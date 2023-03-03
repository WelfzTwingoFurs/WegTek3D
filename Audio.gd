extends AudioStreamPlayer

export var minus = 0

func _process(_delta):
	volume_db = -(80 - ((Worldconfig.player.draw_distance - ((Worldconfig.player.position - get_owner().position).length()))/Worldconfig.player.draw_distance)*80) -minus

func not_zero(numba):
	if numba == 0:
		numba = 1
	return numba

var which = 0
var skin = 0

###############################################################################
#FEET

const feetA1 = preload("res://audio/feet/feet_step_concrete1.wav")
const feetA2 = preload("res://audio/feet/feet_step_concrete2.wav")

const feetB1 = preload("res://audio/feet/feet_step_dirt1.wav")
const feetB2 = preload("res://audio/feet/feet_step_dirt2.wav")

func feet_step():
	skin = get_owner().feet_terrain
	which = (randi() % 2)
	if skin == 0:
		if which == 0:
			set_stream(feetA1)
		if which == 1:
			set_stream(feetA2)
	
	elif skin == 1:
		if which == 0:
			set_stream(feetB1)
		if which == 1:
			set_stream(feetB2)
	
	
	play()


const feetC = preload("res://audio/feet/feet_jump.wav")

func feet_jump():
	set_stream(feetC)
	play()


const feetD = preload("res://audio/feet/feet_land.wav")

func feet_land():
	set_stream(feetD)
	play()


#FEET
###############################################################################
#NPC oh boy here we go
const npc0A1 = preload("res://audio/npc/0/npc_beg1.wav")
const npc0A2 = preload("res://audio/npc/0/npc_beg2.wav")

const npc1A1 = preload("res://audio/npc/1/npc_beg1.wav")
const npc1A2 = preload("res://audio/npc/1/npc_beg2.wav")

func npc_beg():
	#if !playing: #low priority
		which = (randi() % 2)
		skin = get_owner().skin
		if skin == 0:
			if which == 0:
				set_stream(npc0A1)
			elif which == 1:
				set_stream(npc0A2)
		
		elif skin == 1:
			if which == 0:
				set_stream(npc1A1)
			elif which == 1:
				set_stream(npc1A2)
		
		
		play()


const npc0B = preload("res://audio/npc/0/npc_breathe.wav")

const npc1B = preload("res://audio/npc/1/npc_breathe.wav")

func npc_breathe():
	skin = get_owner().skin
	if skin == 0:
		set_stream(npc0B)
	
	elif skin == 1:
			set_stream(npc1B)
	
	
	play()


const npc0C1 = preload("res://audio/npc/0/npc_bump1.wav")
const npc0C2 = preload("res://audio/npc/0/npc_bump2.wav")

const npc1C1 = preload("res://audio/npc/1/npc_bump1.wav")
const npc1C2 = preload("res://audio/npc/1/npc_bump2.wav")

func npc_bump():
	#if !playing: #low priority
		skin = get_owner().skin
		which = (randi() % 2)
		if skin == 0:
			if which == 0:
				set_stream(npc0C1)
			elif which == 1:
				set_stream(npc0C2)
		
		elif skin == 1:
			if which == 0:
				set_stream(npc1C1)
			elif which == 1:
				set_stream(npc1C2)
		
		
		play()


const npc0D = preload("res://audio/npc/0/npc_die.wav")

const npc1D = preload("res://audio/npc/1/npc_die.wav")

func npc_die():
	skin = get_owner().skin
	if skin == 0:
		set_stream(npc0D)
	
	elif skin == 1:
		set_stream(npc1D)
	
	play()


const npc0E1 = preload("res://audio/npc/0/npc_scream1.wav")
const npc0E2 = preload("res://audio/npc/0/npc_scream2.wav")

const npc1E1 = preload("res://audio/npc/1/npc_scream1.wav")
const npc1E2 = preload("res://audio/npc/1/npc_scream2.wav")

func npc_scream():
	skin = get_owner().skin
	which = (randi() % 2)
	if skin == 0:
		if which == 0:
			set_stream(npc0E1)
		elif which == 1:
			set_stream(npc0E2)
	
	elif skin == 1:
		if which == 0:
			set_stream(npc1E1)
		elif which == 1:
			set_stream(npc1E2)
	
	
	play()


const npc0F1 = preload("res://audio/npc/0/npc_talk1.wav")
const npc0F2 = preload("res://audio/npc/0/npc_talk2.wav")

const npc1F1 = preload("res://audio/npc/1/npc_talk1.wav")
const npc1F2 = preload("res://audio/npc/1/npc_talk2.wav")

func npc_talk():
	if !playing:
		skin = get_owner().skin
		which = (randi() % 2)
		if skin == 0:
			if which == 0:
				set_stream(npc0F1)
			elif which == 1:
				set_stream(npc0F2)
		
		elif skin == 1:
			if which == 0:
				set_stream(npc1F1)
			elif which == 1:
				set_stream(npc1F2)
		
		
		play()


const npc0G1 = preload("res://audio/npc/0/npc_trashtalk1.wav")
const npc0G2 = preload("res://audio/npc/0/npc_trashtalk2.wav")

const npc1G1 = preload("res://audio/npc/1/npc_trashtalk1.wav")
const npc1G2 = preload("res://audio/npc/1/npc_trashtalk2.wav")

func npc_trashtalk():
	if !playing:
		skin = get_owner().skin
		which = (randi() % 2)
		if skin == 0:
			if which == 0:
				set_stream(npc0G1)
			elif which == 1:
				set_stream(npc0G2)
		
		elif skin == 1:
			if which == 0:
				set_stream(npc1G1)
			elif which == 1:
				set_stream(npc1G2)
		
		
		play()




const npc0H1 = preload("res://audio/npc/0/npc_treat1.wav")
const npc0H2 = preload("res://audio/npc/0/npc_treat2.wav")

const npc1H1 = preload("res://audio/npc/1/npc_treat1.wav")
const npc1H2 = preload("res://audio/npc/1/npc_treat2.wav")

func npc_treat():
	skin = get_owner().skin
	which = (randi() % 2)
	if skin == 0:
		if which == 0:
			set_stream(npc0H1)
		elif which == 1:
			set_stream(npc0H2)
	
	elif skin == 1:
		if which == 0:
			set_stream(npc1H1)
		elif which == 1:
			set_stream(npc1H2)
	
	
	play()


const npc0I = preload("res://audio/npc/npc_fall1.wav")

const npc1I = preload("res://audio/npc/npc_fall2.wav")

func npc_fall():
	which = (randi() % 2)
	if which == 0:
		set_stream(npc0I)
	
	elif which == 1:
		set_stream(npc1I)
	
	play()


const npc0J1 = preload("res://audio/npc/0/npc_pain1.wav")
const npc0J2 = preload("res://audio/npc/0/npc_pain2.wav")

const npc1J1 = preload("res://audio/npc/1/npc_pain1.wav")
const npc1J2 = preload("res://audio/npc/1/npc_pain2.wav")

func npc_pain():
	skin = get_owner().skin
	which = (randi() % 2)
	if skin == 0:
		if which == 0:
			set_stream(npc0J1)
		elif which == 1:
			set_stream(npc0J2)
	
	elif skin == 1:
		if which == 0:
			set_stream(npc1J1)
		elif which == 1:
			set_stream(npc1J2)
	
	
	play()


#NPC
###############################################################################
#CAR
const carA1 = preload("res://audio/car/car_bump1.wav")
const carA2 = preload("res://audio/car/car_bump1.wav")

func car_bump():
	if !playing:
		which = (randi() % 2)
		if which == 0:
			set_stream(carA1)
		
		elif which == 1:
			set_stream(carA2)
		
		play()


const carB1 = preload("res://audio/car/car_crash1.wav")
const carB2 = preload("res://audio/car/car_crash1.wav")

func car_crash():
	which = (randi() % 2)
	if which == 0:
		set_stream(carB1)
	
	elif which == 1:
		set_stream(carB2)
	
	play()


const carC = preload("res://audio/car/car_tire_skid.wav")

func car_tire_skid():
	if !playing:
		set_stream(carC)
		play()


const carD = preload("res://audio/car/police_siren.wav")

func police_siren():
	if !playing:
		set_stream(carD)
		play()


const car0E = preload("res://audio/car/escort/car_engine_loop.wav")

#const car1E = preload("res://audio/car/police_siren.wav")

func car_engine_loop():
	skin = get_owner().engine
	if skin == 0:
		set_stream(car0E)
		
	
	elif skin == 1:
		set_stream(car0E)
	
	
	play()


const car0F = preload("res://audio/car/escort/car_engine_off.wav")

#const car1F = preload("res://audio/car/police_siren.wav")

func car_engine_off():
	if !playing:
		skin = get_owner().engine
		if skin == 0:
			set_stream(car0F)
		
		elif skin == 1:
			set_stream(car0F)
		
		
		play()


const car0G = preload("res://audio/car/escort/car_engine_start.wav")

#const car1G = preload("res://audio/car/police_siren.wav")

func car_engine_start():
	if !playing:
		skin = get_owner().engine
		if skin == 0:
			set_stream(car0G)
		
		elif skin == 1:
			set_stream(car0G)
		
		
		play()


#CAR
###############################################################################
#WEAPONS
const gunA = preload("res://audio/weapons/gun_empty.wav")
func gun_empty():
	if !playing:
		set_stream(gunA)
		play()

const gunB = preload("res://audio/weapons/gun_melee_hit.wav")
func gun_melee_hit():
	set_stream(gunB)
	play()

const gunC = preload("res://audio/weapons/gun_melee_swing.wav")
func gun_melee_swing():
	set_stream(gunC)
	play()

const gunD = preload("res://audio/weapons/pistol/gun_pistol_hit.wav")
func gun_pistol_hit():
	set_stream(gunD)
	play()

const gunE = preload("res://audio/weapons/pistol/gun_pistol_reload.wav")
func gun_pistol_reload():
	set_stream(gunE)
	play()

const gunG = preload("res://audio/weapons/pistol/gun_pistol_shoot.wav")
func gun_pistol_shoot():
	set_stream(gunG)
	play()

#WEAPONS
###############################################################################
#MUSIC
const radio1 = preload("res://audio/music/radio/Acidental.mp3")
const radio2 = preload("res://audio/music/radio/Annoia.mp3")
const radio3 = preload("res://audio/music/radio/Arcade.mp3")
const radio4 = preload("res://audio/music/radio/Bionic.mp3")
const radio5 = preload("res://audio/music/radio/Bitzagain.mp3")
const radio6 = preload("res://audio/music/radio/Crashy.mp3")
const radio7 = preload("res://audio/music/radio/Doomed.mp3")
const radio8 = preload("res://audio/music/radio/DORK.mp3")
const radio9 = preload("res://audio/music/radio/DROK.mp3")
const radio10 = preload("res://audio/music/radio/FinallyFull.mp3")
const radio11 = preload("res://audio/music/radio/Fuckyou.mp3")
const radio12 = preload("res://audio/music/radio/Nuff.mp3")
const radio13 = preload("res://audio/music/radio/Peaceful.mp3")
const radio14 = preload("res://audio/music/radio/Phone.mp3")
const radio15 = preload("res://audio/music/radio/rippie.mp3")
const radio16 = preload("res://audio/music/radio/RPO1-4.mp3")
const radio17 = preload("res://audio/music/radio/RPO2.mp3")
const radio18 = preload("res://audio/music/radio/Sequel.mp3")
const radio19 = preload("res://audio/music/radio/Sly.mp3")
const radio20 = preload("res://audio/music/radio/Sombreros.mp3")
const radio21 = preload("res://audio/music/radio/Suck.mp3")
const radio22 = preload("res://audio/music/radio/upsNdowns.mp3")
const radio23 = preload("res://audio/music/radio/Weird.mp3")
const radio24 = preload("res://audio/music/radio/Whollo.mp3")

var already_played = []

func radio():
	if !playing:
		if already_played.size() >= 23:
			already_played = []
			which = (randi() % 24)
		
		while already_played.has(which):
			which = (randi() % 24)
		
		if which == 0:
			set_stream(radio1)
		elif which == 1:
			set_stream(radio2)
		elif which == 2:
			set_stream(radio3)
		elif which == 3:
			set_stream(radio4)
		elif which == 4:
			set_stream(radio5)
		elif which == 5:
			set_stream(radio6)
		elif which == 6:
			set_stream(radio7)
		elif which == 7:
			set_stream(radio8)
		elif which == 8:
			set_stream(radio9)
		elif which == 9:
			set_stream(radio10)
		elif which == 10:
			set_stream(radio11)
		elif which == 11:
			set_stream(radio12)
		elif which == 12:
			set_stream(radio13)
		elif which == 13:
			set_stream(radio14)
		elif which == 14:
			set_stream(radio15)
		elif which == 15:
			set_stream(radio16)
		elif which == 16:
			set_stream(radio17)
		elif which == 17:
			set_stream(radio18)
		elif which == 18:
			set_stream(radio19)
		elif which == 19:
			set_stream(radio20)
		elif which == 20:
			set_stream(radio21)
		elif which == 21:
			set_stream(radio22)
		elif which == 22:
			set_stream(radio23)
		elif which == 23:
			set_stream(radio24)
		
		
		already_played.push_back(which)
		play()
