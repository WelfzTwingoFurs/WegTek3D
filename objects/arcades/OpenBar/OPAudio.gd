extends AudioStreamPlayer2D
#TRIANGLE

var musicbg = preload("res://objects/arcades/OpenBar/OPaudioSong.mp3")

func music_bg(): 
	set_stream(musicbg)
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
