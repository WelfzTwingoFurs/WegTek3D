extends AudioStreamPlayer2D

func _ready():
	Global.audio = self

var which

const STEP1 = preload("res://SFX/step1.wav")
const STEP2 = preload("res://SFX/step2.wav")

func STEPs():
	if !playing:#low priority
		which = (randi() % 2)
		if which == 0:
			set_stream(STEP1)
		if which == 1:
			set_stream(STEP2)
		play()

const JUMP = preload("res://SFX/jump.wav")
func JUMPs():
	set_stream(JUMP)
	play()

const JUMPLAND = preload("res://SFX/jumpland.wav")
func JUMPLANDs():
	if !playing:#low priority
		set_stream(JUMPLAND)
		play()

const SHOOT = preload("res://SFX/shoot.wav")
func SHOOTs():
	set_stream(SHOOT)
	play()

const BEEP = preload("res://SFX/beeps.wav")
func BEEPs():
	set_stream(BEEP)
	play()

const BOOMBIG = preload("res://SFX/boombig.wav")
func BOOMBIGs():
	set_stream(BOOMBIG)
	play()

const BOOMMED = preload("res://SFX/boommed.wav")
func BOOMMEDs():
	set_stream(BOOMMED)
	play()

const GETBIG = preload("res://SFX/getbig.wav")
func GETBIGs():
	set_stream(GETBIG)
	play()

const GETMED = preload("res://SFX/getmed.wav")
func GETMEDs():
	set_stream(GETMED)
	play()

const GETSMALL = preload("res://SFX/getsmall.wav")
func GETSMALLs():
	set_stream(GETSMALL)
	play()

const HITHEAD = preload("res://SFX/hithead.wav")
func KICKs():
	set_stream(HITHEAD)
	play()

#const HITHEAD = preload("res://SFX/hithead.wav")
func HITHEADs():
	set_stream(HITHEAD)
	play()

const OUCH = preload("res://SFX/ouch.wav")
func OUCHs():
	set_stream(OUCH)
	play()

const UW = preload("res://SFX/uw.wav")
func UWs():
	set_stream(UW)
	play()

const YAOW = preload("res://SFX/yaow.wav")
func YAOWs():
	set_stream(YAOW)
	play()

const BOOMTINNY = preload("res://SFX/boomtinny.wav")
func BOOMTINNYs():
	set_stream(BOOMTINNY)
	play()

const POW = preload("res://SFX/pow.wav")
func POWs():
	set_stream(POW)
	play()
