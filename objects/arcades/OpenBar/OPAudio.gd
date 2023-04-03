extends AudioStreamPlayer2D
#TRIANGLE

const radio1 = preload("res://objects/arcades/OpenBar/OPaudioSong1.mp3")
const radio2 = preload("res://objects/arcades/OpenBar/OPaudioSong2.mp3")
const radio3 = preload("res://objects/arcades/OpenBar/OPaudioSong3.mp3")
const radio4 = preload("res://objects/arcades/OpenBar/OPaudioSong4.mp3")
const radio5 = preload("res://objects/arcades/OpenBar/OPaudioSong5.mp3")
const radio6 = preload("res://objects/arcades/OpenBar/OPaudioSong6.mp3")


var already_played = []
var which = 0

func radio():
	if already_played.size() >= 6:
		already_played = []
		which = (randi() % 6)
	
	while already_played.has(which):
		which = (randi() % 6)
	
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

var sfxsend = preload("res://objects/arcades/OpenBar/OPaudioSend.mp3")
func sfx_send():
	set_stream(sfxsend)
	play()


#NOISE

var sfxouch = preload("res://objects/arcades/OpenBar/OPaudioOuch.mp3")
func sfx_ouch():
	set_stream(sfxouch)
	play()
