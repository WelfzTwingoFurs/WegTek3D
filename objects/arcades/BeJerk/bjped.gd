extends KinematicBody2D

var motion = Vector2()
var old_targets = []
var target = self
var closest = INF
var speed = 45

func _ready():
	$Col.disabled = false
	speed += randi() % 10
	speed -= randi() % 10
	$AniPlay.playback_speed = float(45)/speed
	health += randi() % 2
	health -= randi() % 2

export var dead = false

func _physics_process(_delta):
	if !dead:
		motion = move_and_slide(motion, Vector2(0,-1))
		
		if abs((position - target.position).length()) < 5:
			closest = INF
			old_targets.push_back(target)
			if old_targets.size() > 60:
				old_targets.remove(0)
			
			var new_target
			for n in get_tree().get_nodes_in_group("bjpath"):
				if !old_targets.has(n):
					if abs((n.position - position).length()) < closest: 
						closest = abs((n.position - position).length())
						new_target = n
			target = new_target
			
		elif target != null:
			#motion = (sign_vetor(position - target.position)*45)*get_parent().get_parent().scale
			if abs(position.x - target.position.x) > 2:
				motion.x = (sign_vetor(position - target.position)*speed).x
			else:
				motion.x = 0
			if abs(position.y - target.position.y) > 2:
				motion.y = (sign_vetor(position - target.position)*speed).y
			else:
				motion.y = 0

func _process(_delta):
	if !dead:
		if (abs(motion.x) > 10) && (abs(motion.y) > 10):
			$Sprite.flip_h = motion_to_flip(motion.x)
			if sign(motion.y) == 1: $AniPlay.play("walkDiagD")
			else: $AniPlay.play("walkDiagU")
		
		else:
			if abs(int(motion.x)) > abs(int(motion.y)):
				$Sprite.flip_h = motion_to_flip(motion.x)
				$AniPlay.play("walkSide")
			elif sign(motion.y) == 1: $AniPlay.play("walkDown")
			else: $AniPlay.play("walkUp")
			
		


var health = 5

func take_damage(dmg):
	motion = Vector2()
	dead = true
	health -= dmg
	if health <= 0:
		if get_parent().player.drive == null:  
			get_parent().get_parent().score += get_parent().get_parent().combo*1500
			get_parent().get_parent().toptimer += 150
			get_parent().get_parent().topstring = str("PEDESTRIAN KILL:+",get_parent().get_parent().combo*1500)
		else:
			get_parent().get_parent().topstring = str("TWAK!ROADKILL BONUS:+",get_parent().get_parent().combo*3500)
			get_parent().get_parent().toptimer += 250
			get_parent().get_parent().score += 3500
			
		get_parent().get_parent().combo += 1
		$AniPlay.play("die")
	else:
		get_parent().get_parent().score += get_parent().get_parent().combo*250
		get_parent().get_parent().toptimer += 25
		get_parent().get_parent().topstring = str("'OUCH':+",get_parent().get_parent().combo*250)
		get_parent().get_parent().combo += 1
		$AniPlay.play("ouch")





func motion_to_flip(n):
	if sign(n) == -1:
		n = true
	else:
		n = false
	return n

func sign_vetor(n):
	n.x = -sign(n.x)
	n.y = -sign(n.y)
	return n
