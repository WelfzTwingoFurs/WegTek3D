extends "res://objects/sprite object physics.gd"

export var speed = 300
export var turn = 0.1
export(bool) var jumpy = false

var distanceXY = Vector2(0,0)

var target = self
var closest = INF
var old_targets = [null]
var new_target = null

func _ready():
	scale_extra = Vector2(0.5,0.5) + Vector2(float(randi()%100)/100, float(randi()%50)/100)
	speed += (randi() % 300)
	
	for n in get_tree().get_nodes_in_group("path"):
		if abs((n.position - position).length()) < closest: 
			closest = abs((n.position - position).length())
			target = n

func _physics_process(_delta):
	if abs(distanceXY.length()) < 5:
		old_targets.push_back(target)
		closest = INF
		for n in get_tree().get_nodes_in_group("path"):
			if !old_targets.has(n):
				if abs((n.position - position).length()) < closest: 
					closest = abs((n.position - position).length())
					new_target = n
		target = new_target
		if old_targets.size() > 5:
			old_targets.remove(0)
	
	
	if target != null:
		motion = lerp(motion,  Vector2(speed, 0).rotated((position - target.position).angle() + PI),  turn)
		rotation_degrees = rad2deg(lerp_angle(deg2rad(rotation_degrees), (position - target.position).angle() + PI/2, 0.05))
		
		distanceXY = position - target.position
	
	

	
	
	
	if $AnimationPlayer != null:
		if (abs(motion.x) > 2) or (abs(motion.y) > 2):
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.stop()
			anim = 0
