extends AudioStreamPlayer

export var minus = -2

func _process(_delta):
	volume_db = -(80 - ((Worldconfig.player.draw_distance - ((Worldconfig.player.position - get_owner().position).length()))/Worldconfig.player.draw_distance)*80) -minus

func not_zero(numba):
	if numba == 0:
		numba = 0.01
	return numba

var which = 0
var skin = 0

###############################################################################
#RANDOM
const ambienceGDTs = preload("res://audio/ambience-gdt.mp3")

func ambienceGDT():
	if !playing:
		set_stream(ambienceGDTs)
		play()


#RANDOM
###############################################################################
#FEET
const feetA1 = preload("res://audio/feet/feet_step_concrete1.wav")
const feetA2 = preload("res://audio/feet/feet_step_concrete2.wav")
const feetA3 = preload("res://audio/feet/feet_step_concrete3.wav")
const feetA4 = preload("res://audio/feet/feet_step_concrete4.wav")
const feetA5 = preload("res://audio/feet/feet_step_concrete5.wav")

const feetB1 = preload("res://audio/feet/feet_step_dirt1.wav")
const feetB2 = preload("res://audio/feet/feet_step_dirt2.wav")
const feetB3 = preload("res://audio/feet/feet_step_dirt3.wav")

func feet_step():
	skin = get_owner().feet_terrain
	
	if skin == 0:
		which = (randi() % 5)
		if which == 0:
			set_stream(feetA1)
		elif which == 1:
			set_stream(feetA2)
		elif which == 2:
			set_stream(feetA3)
		elif which == 3:
			set_stream(feetA4)
		else:#if which == 1:
			set_stream(feetA5)
	
	elif skin == 1:
		which = (randi() % 3)
		if which == 0:
			set_stream(feetB1)
		elif which == 1:
			set_stream(feetB2)
		else:
			set_stream(feetB3)
	
	
	play()


const feetC1 = preload("res://audio/feet/feet_jump1.wav")
const feetC2 = preload("res://audio/feet/feet_jump2.wav")

func feet_jump():
	which = randi() % 2
	if which == 0:
		set_stream(feetC1)
	else:
		set_stream(feetC2)
	play()


const feetD1 = preload("res://audio/feet/feet_land1.wav")
const feetD2 = preload("res://audio/feet/feet_land2.wav")

func feet_land():
	which = randi() % 2
	if which == 0:
		set_stream(feetD1)
	else:
		set_stream(feetD2)
	play()


#FEET
###############################################################################
#NPC oh boy here we go
const npcSCIA1 = preload("res://audio/npc/sci/npc_beg1.wav") #PLACEHOLDER 1
const npcSCIA2 = preload("res://audio/npc/sci/npc_beg2.wav")

const npcBARNEYA1 = preload("res://audio/npc/barney/npc_beg1.wav") #PLACEHOLDER 2
const npcBARNEYA2 = preload("res://audio/npc/barney/npc_beg2.wav")

const npc0A1 = preload("res://audio/npc/0/beg1.wav") #ME
const npc0A2 = preload("res://audio/npc/0/beg2.wav")
const npc0A3 = preload("res://audio/npc/0/beg3.wav")

const npc1A1 = preload("res://audio/npc/1/beg1.wav") #MOM
const npc1A2 = preload("res://audio/npc/1/beg2.wav")
const npc1A3 = preload("res://audio/npc/1/beg3.wav")
const npc1A4 = preload("res://audio/npc/1/beg4.wav")
const npc1A5 = preload("res://audio/npc/1/beg5.wav")
const npc1A6 = preload("res://audio/npc/1/beg6.wav")

const npc2A = preload("res://audio/npc/2/beg1.wav") #RODS

const npc3A1 = preload("res://audio/npc/3/beg1.wav") #DAD
const npc3A2 = preload("res://audio/npc/3/beg2.wav")
const npc3A3 = preload("res://audio/npc/3/beg3.wav")
const npc3A4 = preload("res://audio/npc/3/beg4.wav")

func npc_beg():
	#if !playing: #low priority
		skin = get_owner().skin
		if skin == 0: #ME
			which = (randi() % 3)
			if which == 0:
				set_stream(npc0A1)
			elif which == 1:
				set_stream(npc0A2)
			else:#if which == 2:
				set_stream(npc0A3)
		
		elif skin == 1: #MOM
			which = (randi() % 6)
			if which == 0:
				set_stream(npc1A1)
			elif which == 1:
				set_stream(npc1A2)
			elif which == 2:
				set_stream(npc1A3)
			elif which == 3:
				set_stream(npc1A4)
			elif which == 4:
				set_stream(npc1A5)
			else:#
				set_stream(npc1A6)
		
		elif skin == 2: #RODS
			which = randi() % 3
			if which == 0:
				set_stream(npc2A)
			elif which == 1:
				set_stream(npc2E) #scream
			else:
				set_stream(npc2J2) #pain2
		
		elif skin == 3: #DAD
			which = randi() % 4
			if which == 0:
				set_stream(npc3A1)
			elif which == 1:
				set_stream(npc3A2)
			elif which == 2:
				set_stream(npc3A3)
			else:
				set_stream(npc3A4)
		
		
		
		elif skin == 4:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcSCIA1)
			else:#if which == 1:
				set_stream(npcSCIA2)
		
		else:#if skin == 2:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcBARNEYA1)
			else:#if which == 1:
				set_stream(npcBARNEYA2)
		
		play()


const npcSCIB = preload("res://audio/npc/sci/npc_breathe.wav")

const npcBARNEYB = preload("res://audio/npc/barney/npc_breathe.wav")

const npc0B1 = preload("res://audio/npc/0/breathe1.wav")
const npc0B2 = preload("res://audio/npc/0/breathe2.wav")

const npc1B = preload("res://audio/npc/1/breathe1.wav")

const npc2B = preload("res://audio/npc/2/breathe.wav")

const npc3B1 = preload("res://audio/npc/3/breathe1.wav")
const npc3B2 = preload("res://audio/npc/3/breathe2.wav")
const npc3B3 = preload("res://audio/npc/3/breathe3.wav")

func npc_breathe():
	skin = get_owner().skin
	if skin == 0: #ME
		which = (randi() % 2)
		if which == 0:
			set_stream(npc0B1)
		else:
			set_stream(npc0B2)
	
	elif skin == 1: #MOM
		set_stream(npc1B)
	
	elif skin == 2: #RODS
		set_stream(npc2B)
	
	elif skin == 3: #DAD
		which = (randi() % 3)
		if which == 0:
			set_stream(npc3B1)
		elif which == 1:
			set_stream(npc3B2)
		else:
			set_stream(npc3B3)
	
	
	elif skin == 4:
		set_stream(npcSCIB)
	else:
		set_stream(npcBARNEYB)
	
	play()


const npcSCIC1 = preload("res://audio/npc/sci/npc_bump1.wav")
const npcSCIC2 = preload("res://audio/npc/sci/npc_bump2.wav")

const npcBARNEYC1 = preload("res://audio/npc/barney/npc_bump1.wav")
const npcBARNEYC2 = preload("res://audio/npc/barney/npc_bump2.wav")

const npc0C1 = preload("res://audio/npc/0/bump1.wav")
const npc0C2 = preload("res://audio/npc/0/bump2.wav")
const npc0C3 = preload("res://audio/npc/0/bump3.wav")
const npc0C4 = preload("res://audio/npc/0/bump4.wav")
const npc0C5 = preload("res://audio/npc/0/bump5.wav")
const npc0C6 = preload("res://audio/npc/0/bump6.wav")
const npc0C7 = preload("res://audio/npc/0/bump7.wav")

const npc1C1 = preload("res://audio/npc/1/bump1.wav")
const npc1C2 = preload("res://audio/npc/1/bump2.wav")
const npc1C3 = preload("res://audio/npc/1/bump3.wav")

const npc2C1 = preload("res://audio/npc/2/bump1.wav")
const npc2C2 = preload("res://audio/npc/2/bump2.wav")

const npc3C1 = preload("res://audio/npc/3/bump1.wav")
const npc3C2 = preload("res://audio/npc/3/bump2.wav")
const npc3C3 = preload("res://audio/npc/3/bump3.wav")
const npc3C4 = preload("res://audio/npc/3/bump4.wav")
const npc3C5 = preload("res://audio/npc/3/bump5.wav")
const npc3C6 = preload("res://audio/npc/3/bump6.wav")

func npc_bump():
	if !playing: #low priority
		skin = get_owner().skin
		if skin == 0: #ME
			which = (randi() % 7)
			if which == 0:
				set_stream(npc0C1)
			elif which == 1:
				set_stream(npc0C2)
			elif which == 2:
				set_stream(npc0C3)
			elif which == 3:
				set_stream(npc0C4)
			elif which == 4:
				set_stream(npc0C5)
			elif which == 5:
				set_stream(npc0C6)
			else:#if which == 6:
				set_stream(npc0C7)
		
		elif skin == 1: #MOM
			which = (randi() % 3)
			if which == 0:
				set_stream(npc1C1)
			elif which == 1:
				set_stream(npc1C2)
			else:
				set_stream(npc1C3)
		
		elif skin == 2: #RODS
			which = randi() % 2
			if which == 0:
				set_stream(npc2C1)
			else:
				set_stream(npc2C2)
			
			
		
		elif skin == 3: #DAD
			which = (randi() % 5)
			if which == 0:
				set_stream(npc3C1)
			elif which == 1:
				set_stream(npc3C2)
			elif which == 2:
				set_stream(npc3C3)
			elif which == 3:
				set_stream(npc3C4)
			elif which == 4:
				set_stream(npc3C5)
			else:
				set_stream(npc3C6)
		
		elif skin == 4:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcSCIC1)
			else:#if which == 1:
				set_stream(npcSCIC2)
		
		else:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcBARNEYC1)
			else:#if which == 1:
				set_stream(npcBARNEYC2)
		
		play()


const npcSCID = preload("res://audio/npc/sci/npc_die.wav")

const npcBARNEYD = preload("res://audio/npc/barney/npc_die.wav")

const npc0D1 = preload("res://audio/npc/0/die1.wav")
const npc0D2 = preload("res://audio/npc/0/die2.wav")
const npc0D3 = preload("res://audio/npc/0/die3.wav")

const npc1D = preload("res://audio/npc/1/die.wav")

#const npc2D = preload("")

const npc3D1 = preload("res://audio/npc/3/die1.wav")
const npc3D2 = preload("res://audio/npc/3/die2.wav")
const npc3D3 = preload("res://audio/npc/3/die3.wav")
const npc3D4 = preload("res://audio/npc/3/die4.wav")

func npc_die():
	skin = get_owner().skin
	if skin == 0: #ME
		which = (randi() % 3)
		if which == 0:
			set_stream(npc0D1)
		elif which == 1:
			set_stream(npc0D2)
		else:
			set_stream(npc0D3)
	
	elif skin == 1: #MOM
		set_stream(npc1D)
	
	elif skin == 2: #RODS
		set_stream(npc2C2) #bump2 sound
	
	elif skin == 3: #DAD
		which = (randi() % 4)
		if which == 0:
			set_stream(npc3D1)
		elif which == 1:
			set_stream(npc3D2)
		elif which == 2:
			set_stream(npc3D3)
		else:
			set_stream(npc3D4)
	
	elif skin == 4:
		set_stream(npcSCID)
	
	else:
		set_stream(npcBARNEYD)
	
	play()


const npcSCIE1 = preload("res://audio/npc/sci/npc_scream1.wav")
const npcSCIE2 = preload("res://audio/npc/sci/npc_scream2.wav")

const npcBARNEYE1 = preload("res://audio/npc/sci/npc_scream1.wav")
const npcBARNEYE2 = preload("res://audio/npc/sci/npc_scream2.wav")

const npc0E1 = preload("res://audio/npc/0/scream1.wav")
const npc0E2 = preload("res://audio/npc/0/scream2.wav")
const npc0E3 = preload("res://audio/npc/0/scream3.wav")
const npc0E4 = preload("res://audio/npc/0/scream4.wav")
const npc0E5 = preload("res://audio/npc/0/scream5.wav")

const npc1E1 = preload("res://audio/npc/1/scream1.wav")
const npc1E2 = preload("res://audio/npc/1/scream2.wav")
const npc1E3 = preload("res://audio/npc/1/scream3.wav")
const npc1E4 = preload("res://audio/npc/1/scream4.wav")

const npc2E = preload("res://audio/npc/2/scream1.wav")

const npc3E1 = preload("res://audio/npc/3/scream1.wav")
const npc3E2 = preload("res://audio/npc/3/scream2.wav")
const npc3E3 = preload("res://audio/npc/3/scream3.wav")
const npc3E4 = preload("res://audio/npc/3/scream4.wav")

func npc_scream():
	skin = get_owner().skin
	
	if skin == 0: #ME
		which = (randi() % 5)
		if which == 0:
			set_stream(npc0E1)
		elif which == 1:
			set_stream(npc0E2)
		elif which == 2:
			set_stream(npc0E3)
		elif which == 3:
			set_stream(npc0E4)
		else:#if which == 4:
			set_stream(npc0E5)
	
	elif skin == 1: #MOM
		which = (randi() % 4)
		if which == 0:
			set_stream(npc1E1)
		elif which == 1:
			set_stream(npc1E2)
		elif which == 2:
			set_stream(npc1E3)
		else:
			set_stream(npc1E4)
	
	elif skin == 2: #RODS
		which = randi() % 2
		if which == 0:
			set_stream(npc2E)
		else:
			set_stream(npc2J2) #pain2 sound
	
	elif skin == 3: #DAD
		which = (randi() % 4)
		if which == 0:
			set_stream(npc3E1)
		elif which == 1:
			set_stream(npc3E2)
		elif which == 2:
			set_stream(npc3E3)
		else:
			set_stream(npc3E4)
	
	elif skin == 4:
		which = (randi() % 2)
		if which == 0:
			set_stream(npcSCIE1)
		else:
			set_stream(npcSCIE2)
	
	else:
		which = (randi() % 2)
		if which == 0:
			set_stream(npcBARNEYE1)
		else:
			set_stream(npcBARNEYE2)
	
	play()


const npcSCIF1 = preload("res://audio/npc/sci/npc_talk1.wav")
const npcSCIF2 = preload("res://audio/npc/sci/npc_talk2.wav")

const npcBARNEYF1 = preload("res://audio/npc/barney/npc_talk1.wav")
const npcBARNEYF2 = preload("res://audio/npc/barney/npc_talk2.wav")

const npc0F1 = preload("res://audio/npc/0/talk1.wav")
const npc0F2 = preload("res://audio/npc/0/talk2.wav")
const npc0F3 = preload("res://audio/npc/0/talk3.wav")
const npc0F4 = preload("res://audio/npc/0/talk4.wav")

const npc1F1 = preload("res://audio/npc/1/talk1.wav")
const npc1F2 = preload("res://audio/npc/1/talk2.wav")
const npc1F3 = preload("res://audio/npc/1/talk3.wav")
const npc1F4 = preload("res://audio/npc/1/talk4.wav")
const npc1F5 = preload("res://audio/npc/1/talk5.wav")

const npc2F1 = preload("res://audio/npc/2/talk1.wav")
const npc2F2 = preload("res://audio/npc/2/talk2.wav")
const npc2F3 = preload("res://audio/npc/2/talk3.wav")

const npc3F1 = preload("res://audio/npc/3/talk1.wav")
const npc3F2 = preload("res://audio/npc/3/talk2.wav")
const npc3F3 = preload("res://audio/npc/3/talk3.wav")
const npc3F4 = preload("res://audio/npc/3/talk4.wav")
const npc3F5 = preload("res://audio/npc/3/talk5.wav")

func npc_talk():
	if !playing:
		skin = get_owner().skin
		
		if skin == 0: #ME
			which = (randi() % 4)
			if which == 0:
				set_stream(npc0F1)
			elif which == 1:
				set_stream(npc0F2)
			elif which == 2:
				set_stream(npc0F3)
			else:
				set_stream(npc0F4)
		
		elif skin == 1: #MOM
			which = (randi() % 5)
			if which == 0:
				set_stream(npc1F1)
			elif which == 1:
				set_stream(npc1F2)
			elif which == 2:
				set_stream(npc1F3)
			elif which == 3:
				set_stream(npc1F4)
			else:
				set_stream(npc1F5)
		
		elif skin == 2: #RODS
			which = randi() % 3
			if which == 0:
				set_stream(npc2F1)
			elif which == 1:
				set_stream(npc2F2)
			else:
				set_stream(npc2F3)
		
		elif skin == 3: #DAD
			which = (randi() % 5)
			if which == 0:
				set_stream(npc3F1)
			elif which == 1:
				set_stream(npc3F2)
			elif which == 2:
				set_stream(npc3F3)
			elif which == 3:
				set_stream(npc3F4)
			else:
				set_stream(npc3F5)
		
		elif skin == 4:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcSCIF1)
			else:#if which == 1:
				set_stream(npcSCIF2)
		
		else:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcBARNEYF1)
			else:#if which == 1:
				set_stream(npcBARNEYF2)
		
		play()


const npcSCIG1 = preload("res://audio/npc/sci/npc_trashtalk1.wav")
const npcSCIG2 = preload("res://audio/npc/sci/npc_trashtalk2.wav")

const npcBARNEYG1 = preload("res://audio/npc/barney/npc_trashtalk1.wav")
const npcBARNEYG2 = preload("res://audio/npc/barney/npc_trashtalk2.wav")

const npc0G1 = preload("res://audio/npc/0/trashtalk1.wav")
const npc0G2 = preload("res://audio/npc/0/trashtalk2.wav")
const npc0G3 = preload("res://audio/npc/0/trashtalk3.wav")
const npc0G4 = preload("res://audio/npc/0/trashtalk4.wav")

const npc1G1 = preload("res://audio/npc/1/trashtalk1.wav")
const npc1G2 = preload("res://audio/npc/1/trashtalk2.wav")
const npc1G3 = preload("res://audio/npc/1/trashtalk3.wav")

const npc2G1 = preload("res://audio/npc/2/trashtalk1.wav")
const npc2G2 = preload("res://audio/npc/2/trashtalk2.wav")

const npc3G1 = preload("res://audio/npc/3/trashtalk1.wav")
const npc3G2 = preload("res://audio/npc/3/trashtalk2.wav")
const npc3G3 = preload("res://audio/npc/3/trashtalk3.wav")
const npc3G4 = preload("res://audio/npc/3/trashtalk4.wav")
const npc3G5 = preload("res://audio/npc/3/trashtalk5.wav")

func npc_trashtalk():
	if !playing:
		skin = get_owner().skin
		
		if skin == 0: #ME
			which = (randi() % 4)
			if which == 0:
				set_stream(npc0G1)
			elif which == 1:
				set_stream(npc0G2)
			elif which == 2:
				set_stream(npc0G3)
			else:#
				set_stream(npc0G4)
				
				
		elif skin == 1: #MOM
			which = (randi() % 3)
			if which == 0:
				set_stream(npc1G1)
			elif which == 1:
				set_stream(npc1G2)
			else:#
				set_stream(npc1G3)
		
		elif skin == 2: #RODS
			which = (randi() % 2)
			if which == 0:
				set_stream(npc2G1)
			else:
				set_stream(npc2G2)
		
		elif skin == 3: #DAD
			which = (randi() % 4)
			if which == 0:
				set_stream(npc3G1)
			elif which == 1:
				set_stream(npc3G2)
			elif which == 2:
				set_stream(npc3G3)
			elif which == 3:
				set_stream(npc3G4)
			else:#
				set_stream(npc3G5)
		
		
		elif skin == 4:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcSCIG1)
			else:
				set_stream(npcSCIG2)
		
		else:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcBARNEYG1)
			else:
				set_stream(npcBARNEYG2)
		
		play()


const npcSCIH1 = preload("res://audio/npc/sci/npc_treat1.wav")
const npcSCIH2 = preload("res://audio/npc/sci/npc_treat2.wav")

const npcBARNEYH1 = preload("res://audio/npc/barney/npc_treat1.wav")
const npcBARNEYH2 = preload("res://audio/npc/barney/npc_treat2.wav")

const npc0H1 = preload("res://audio/npc/0/treat1.wav")
const npc0H2 = preload("res://audio/npc/0/treat2.wav")
const npc0H3 = preload("res://audio/npc/0/treat3.wav")
const npc0H4 = preload("res://audio/npc/0/treat4.wav")
const npc0H5 = preload("res://audio/npc/0/treat5.wav")

const npc1H1 = preload("res://audio/npc/1/treat1.wav")
const npc1H2 = preload("res://audio/npc/1/treat2.wav")
const npc1H3 = preload("res://audio/npc/1/treat3.wav")
const npc1H4 = preload("res://audio/npc/1/treat4.wav")

const npc2H1 = preload("res://audio/npc/2/treat1.wav")
const npc2H2 = preload("res://audio/npc/2/treat2.wav")
const npc2H3 = preload("res://audio/npc/2/treat3.wav")

const npc3H1 = preload("res://audio/npc/3/treat1.wav")
const npc3H2 = preload("res://audio/npc/3/treat2.wav")
const npc3H3 = preload("res://audio/npc/3/treat3.wav")

func npc_treat():
	if !playing:
		skin = get_owner().skin
		
		if skin == 0: #ME
			which = (randi() % 5)
			if which == 0:
				set_stream(npc0H1)
			elif which == 1:
				set_stream(npc0H2)
			elif which == 2:
				set_stream(npc0H3)
			elif which == 3:
				set_stream(npc0H4)
			else:#if which == 2:
				set_stream(npc0H5)
		
		elif skin == 1: #MOM
			which = (randi() % 4)
			if which == 0:
				set_stream(npc1H1)
			elif which == 1:
				set_stream(npc1H2)
			elif which == 2:
				set_stream(npc1H3)
			else:
				set_stream(npc1H4)
		
		elif skin == 2: #RODS
			which = (randi() % 3)
			if which == 0:
				set_stream(npc2H1)
			elif which == 1:
				set_stream(npc2H2)
			else:
				set_stream(npc2H3)
		
		elif skin == 3: #DAD
			which = (randi() % 3)
			if which == 0:
				set_stream(npc3H1)
			elif which == 1:
				set_stream(npc3H2)
			else:
				set_stream(npc3H3)
		
		elif skin == 4:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcSCIH1)
			else:#if which == 1:
				set_stream(npcSCIH2)
		
		else:
			which = (randi() % 2)
			if which == 0:
				set_stream(npcSCIH1)
			else:#if which == 1:
				set_stream(npcSCIH2)
		
		
		play()


const npcI1 = preload("res://audio/npc/npc_fall1.wav")

const npcI2 = preload("res://audio/npc/npc_fall2.wav")

func npc_fall():
	which = (randi() % 2)
	if which == 0:
		set_stream(npcI1)
	
	else:#if which == 1:
		set_stream(npcI2)
	
	play()


const npcSCIJ1 = preload("res://audio/npc/sci/npc_pain1.wav")
const npcSCIJ2 = preload("res://audio/npc/sci/npc_pain2.wav")

const npcBARNEYJ1 = preload("res://audio/npc/barney/npc_pain1.wav")
const npcBARNEYJ2 = preload("res://audio/npc/barney/npc_pain2.wav")

const npc0J1 = preload("res://audio/npc/0/pain1.wav")
const npc0J2 = preload("res://audio/npc/0/pain2.wav")
const npc0J3 = preload("res://audio/npc/0/pain3.wav")
const npc0J4 = preload("res://audio/npc/0/pain4.wav")
const npc0J5 = preload("res://audio/npc/0/pain5.wav")

const npc1J1 = preload("res://audio/npc/1/pain1.wav")
const npc1J2 = preload("res://audio/npc/1/pain2.wav")
const npc1J3 = preload("res://audio/npc/1/pain3.wav")

const npc2J1 = preload("res://audio/npc/2/pain1.wav")
const npc2J2 = preload("res://audio/npc/2/pain2.wav")
const npc2J3 = preload("res://audio/npc/2/pain3.wav")
const npc2J4 = preload("res://audio/npc/2/pain4.wav")

const npc3J1 = preload("res://audio/npc/3/pain1.wav")
const npc3J2 = preload("res://audio/npc/3/pain2.wav")
const npc3J3 = preload("res://audio/npc/3/pain3.wav")
const npc3J4 = preload("res://audio/npc/3/pain4.wav")
const npc3J5 = preload("res://audio/npc/3/pain5.wav")
const npc3J6 = preload("res://audio/npc/3/pain6.wav")

func npc_pain():
	skin = get_owner().skin
	
	if skin == 0: #ME
		which = (randi() % 5)
		if which == 0:
			set_stream(npc0J1)
		elif which == 1:
			set_stream(npc0J2)
		elif which == 2:
			set_stream(npc0J3)
		elif which == 3:
			set_stream(npc0J4)
		else:
			set_stream(npc0J5)
			
	
	elif skin == 1: #MOM
		which = (randi() % 3)
		if which == 0:
			set_stream(npc1J1)
		elif which == 1:
			set_stream(npc1J2)
		else:
			set_stream(npc1J3)
	
	elif skin == 2: #RODS
		which = (randi() % 4)
		if which == 0:
			set_stream(npc2J1)
		elif which == 1:
			set_stream(npc2J2)
		elif which == 2:
			set_stream(npc2J3)
		else:
			set_stream(npc2J4)
	
	elif skin == 3: #DAD
		which = (randi() % 6)
		if which == 0:
			set_stream(npc3J1)
		elif which == 1:
			set_stream(npc3J2)
		elif which == 2:
			set_stream(npc3J3)
		elif which == 3:
			set_stream(npc3J4)
		elif which == 4:
			set_stream(npc3J5)
		else:
			set_stream(npc3J6)
	
	
	elif skin == 4:
		which = (randi() % 2)
		if which == 0:
			set_stream(npcSCIJ1)
		else:#if which == 1:
			set_stream(npcSCIJ2)
	
	else:
		which = (randi() % 2)
		if which == 0:
			set_stream(npcBARNEYJ1)
		else:#if which == 1:
			set_stream(npcBARNEYJ2)
	
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
		
		else:#if which == 1:
			set_stream(carA2)
		
		play()


const carB1 = preload("res://audio/car/car_crash1.wav")
const carB2 = preload("res://audio/car/car_crash1.wav")

func car_crash():
	which = (randi() % 2)
	if which == 0:
		set_stream(carB1)
	
	else:#if which == 1:
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
		
	
	else:
		set_stream(car0E)
	
	
	play()


const car0F = preload("res://audio/car/escort/car_engine_off.wav")

#const car1F = preload("res://audio/car/police_siren.wav")

func car_engine_off():
	if !playing:
		skin = get_owner().engine
		if skin == 0:
			set_stream(car0F)
		
		else:
			set_stream(car0F)
		
		
		play()


const car0G = preload("res://audio/car/escort/car_engine_start.wav")

#const car1G = preload("res://audio/car/police_siren.wav")

func car_engine_start():
	if !playing:
		skin = get_owner().engine
		if skin == 0:
			set_stream(car0G)
		
		else:
			set_stream(car0G)
		
		
		play()

const carH1 = preload("res://audio/car/car_land1.wav")
const carH2 = preload("res://audio/car/car_land2.wav")


func car_land():
	which = (randi() % 2)
	if which == 0:
		set_stream(carH1)
	
	else:#if which == 1:
		set_stream(carH2)
	
	play()


#CAR
###############################################################################
#WEAPONS
const gunA = preload("res://audio/weapons/gun_empty.wav")
func gun_empty():
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
