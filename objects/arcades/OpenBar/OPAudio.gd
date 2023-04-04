extends AudioStreamPlayer2D
#TRIANGLE


const over = preload("res://objects/arcades/OpenBar/OPaudioSongGameover.mp3")
func gameover():
	set_stream(over)
	play()

const win = preload("res://objects/arcades/OpenBar/OPaudioSongWin.mp3")
func win_song():
	set_stream(win)
	play()

const radio1 = preload("res://objects/arcades/OpenBar/OPaudioSong1.mp3")
const radio2 = preload("res://objects/arcades/OpenBar/OPaudioSong2.mp3")
const radio3 = preload("res://objects/arcades/OpenBar/OPaudioSong3.mp3")
const radio4 = preload("res://objects/arcades/OpenBar/OPaudioSong4.mp3")
const radio5 = preload("res://objects/arcades/OpenBar/OPaudioSong5.mp3")
const radio6 = preload("res://objects/arcades/OpenBar/OPaudioSong6.mp3")
const radio7 = preload("res://objects/arcades/OpenBar/OPaudioSong7.mp3")
const radio8 = preload("res://objects/arcades/OpenBar/OPaudioSong8.mp3")
const radio9 = preload("res://objects/arcades/OpenBar/OPaudioSong9.mp3")
const radio10 = preload("res://objects/arcades/OpenBar/OPaudioSong10.mp3")
const radio11 = preload("res://objects/arcades/OpenBar/OPaudioSong11.mp3")
const radio12 = preload("res://objects/arcades/OpenBar/OPaudioSong12.mp3")
const radio13 = preload("res://objects/arcades/OpenBar/OPaudioSong13.mp3")
const radio14 = preload("res://objects/arcades/OpenBar/OPaudioSong14.mp3")
const radio15 = preload("res://objects/arcades/OpenBar/OPaudioSong15.mp3")
const radio16 = preload("res://objects/arcades/OpenBar/OPaudioSong16.mp3")
const radio17 = preload("res://objects/arcades/OpenBar/OPaudioSong17.mp3")
const radio18 = preload("res://objects/arcades/OpenBar/OPaudioSong18.mp3")
const radio19 = preload("res://objects/arcades/OpenBar/OPaudioSong19.mp3")
const radio20 = preload("res://objects/arcades/OpenBar/OPaudioSong20.mp3")
const radio21 = preload("res://objects/arcades/OpenBar/OPaudioSong21.mp3")


var already_played = []
var which = 0

func radio():
	which = (randi() % 21)
	if already_played.size() >= 21:
		already_played = []
		which = (randi() % 21)
	
	while already_played.has(which):
		which = (randi() % 21)
	
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
	
	already_played.push_back(which)
	play()


#SQUARE

var sfxget = preload("res://objects/arcades/OpenBar/OPaudioGet.mp3")
func sfx_get(pitch):
	pitch_scale = 2+pitch
	set_stream(sfxget)
	play()

var sfxjumpscore = preload("res://objects/arcades/OpenBar/OPaudioScore.mp3")
func sfx_jumpscore():
	set_stream(sfxjumpscore)
	play()

var sfxjump = preload("res://objects/arcades/OpenBar/OPaudioJump.mp3")
func sfx_jump(pitch):
	pitch_scale = 1+(1-(pitch + 112)/256)
	set_stream(sfxjump)
	play()

var gates = preload("res://objects/arcades/OpenBar/OPaudioGate.mp3")
func gate():
	pitch_scale = 1
	set_stream(gates)
	play()

var ais = preload("res://objects/arcades/OpenBar/OPaudioAi.mp3")
func ai():
	pitch_scale = 1
	set_stream(ais)
	play()

#NOISE

var sfxouch = preload("res://objects/arcades/OpenBar/OPaudioOuch.mp3")
func sfx_ouch():
	pitch_scale = 1
	set_stream(sfxouch)
	play()

var steps = preload("res://objects/arcades/OpenBar/OPaudioStep.mp3")
func step():
	pitch_scale = 1
	set_stream(steps)
	play()

var lands = preload("res://objects/arcades/OpenBar/OPaudioLand.mp3")
func land():
	pitch_scale = 1
	set_stream(lands)
	play()

var trucks = preload("res://objects/arcades/OpenBar/OPaudioTruck.mp3")
func truck():
	pitch_scale = 1
	set_stream(trucks)
	play()
