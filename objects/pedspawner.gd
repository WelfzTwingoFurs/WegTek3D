extends Node2D

var targets = []

func _ready():
	Worldconfig.npcs = 0
	for n in get_tree().get_nodes_in_group("path"):
		targets.push_back(n)
	
	bullshit = OS.get_system_time_secs() + 3
var bullshit

var ok_targets = []

export var max_npcs = 10
export var spawn_bunch = 5

func _process(_delta):
	if (OS.get_system_time_secs() > bullshit) && (Worldconfig.npcs < max_npcs):
			if (OS.get_system_time_secs() % 3 == 0):
				for n in targets.size():
					var rot_object   = rad_overflow((targets[n].position-Worldconfig.player.position).angle()-PI/2)
					var dist = (targets[n].position - Worldconfig.player.position).length()
					if (dist < Worldconfig.player.draw_distance) && ((dist > Worldconfig.player.draw_distance/Worldconfig.player.lod_ddist_divi) or ((Worldconfig.player.rotation_angle > PI/2 && Worldconfig.player.rotation_angle < 3*PI/2 && (rot_object < Worldconfig.player.rot_minus90 or rot_object > Worldconfig.player.rot_plus90))   or   (rot_object < Worldconfig.player.rot_minus90 && rot_object > Worldconfig.player.rot_plus90))):
					#if ((targets[n].position - Worldconfig.player.position).length() > Worldconfig.player.draw_distance/Worldconfig.player.lod_ddist_divi):# or ((Worldconfig.player.rotation_angle > PI/2 && Worldconfig.player.rotation_angle < 3*PI/2 && (rot_object < Worldconfig.player.rot_minus90 or rot_object > Worldconfig.player.rot_plus90))   or   (rot_object < Worldconfig.player.rot_minus90 && rot_object > Worldconfig.player.rot_plus90)):
						ok_targets.push_back(targets[n])
				
				if ok_targets.size() != 0:
					shoot()
			
			else:
				ok_targets = []

const shot = preload("res://objects/ped.tscn")
func shoot():
	var instance = shot.instance()
	instance.position = ok_targets[randi() % ok_targets.size()].position
	instance.positionZ = -9999
	get_parent().add_child(instance)
	Worldconfig.npcs += 1









func rad_overflow(N):
	if N > PI*2:
		N -= PI*2
	elif N < 0:
		N += PI*2
	
	return N
