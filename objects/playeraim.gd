extends "res://sprite object physics.gd"

var original
var counter = 1
export var loop = false

func _process(_delta):
	original = Worldconfig.player.draw_distance
	#positionZ = lerp(positionZ, Worldconfig.playeraim, 1)
	#position = lerp(position, Worldconfig.player.position + Vector2(0,Worldconfig.player.draw_distance*0.0045).rotated(Worldconfig.player.rotation_angle), 1)
	
	positionZ = counter*Worldconfig.playeraim/4
	
	
	if loop:
		counter += 0.01
		if counter > 1:
			counter = 0.1
		
		position = Worldconfig.player.position + Vector2(0,counter*Worldconfig.player.draw_distance*0.05).rotated(Worldconfig.player.rotation_angle)
	
	else:
		position = Worldconfig.player.position + Vector2(0,Worldconfig.player.draw_distance*0.0045).rotated(Worldconfig.player.rotation_angle)/4
		#position = Vector2(0,Worldconfig.player.draw_distance*0.0045).rotated(Worldconfig.player.rotation_angle)
