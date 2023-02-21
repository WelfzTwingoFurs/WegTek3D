extends KinematicBody2D

export var spr_height = 0
export var positionZ = 0
export var anim = 0
export var scale_extra = Vector2(float(1),float(1))
export(Texture) var texture = preload("res://assets/sprites trees.png")
export var vframes = 1
export var hframes = 10
export var rotations = 1
export var darkness = 1
export var dynamic_darkness = true
export var dontScale = 0
export var dontZ = false
var stepover = false
var shadow = false

var daddy = null

func _ready():
	if anim > vframes*hframes:
		anim = 0
	
	if $CollisionShape2D.position != Vector2(0,0):
		position = to_global($CollisionShape2D.position)
		$CollisionShape2D.position = Vector2(0,0)


var switch = 0

func _process(_delta):
	if daddy != null:
		if daddy == Worldconfig.playercar && !Worldconfig.player.camera:
			anim = 1
		else:
			anim = 0
		
		if abs(switch) == 0:
			position = daddy.lightFT
			rotation_degrees = daddy.rotation_degrees - 90
		elif abs(switch) == 1:
			position = daddy.lightFB
			rotation_degrees = daddy.rotation_degrees - 90
		elif abs(switch) == 2:
			position = daddy.lightRT
			rotation_degrees = daddy.rotation_degrees + 90
		elif abs(switch) == 3:
			position = daddy.lightRB
			rotation_degrees = daddy.rotation_degrees + 90
		#elif abs(switch) == 4:
		#	position = daddy.driver
		#	rotation_degrees = daddy.rotation_degrees - 90
		
		
		
	if sign(switch) == -1:
		dontScale = -1
	
#	collide()
#
#
#
#var col_sprites = []
#var col_walls = []
#var col_floors = []
#
#func collide():
#	for n in col_sprites.size():
#		add_collision_exception_with(col_sprites[n])
#
#	for n in col_walls.size():
#		add_collision_exception_with(col_walls[n])
#
#	for n in col_floors.size():
#		add_collision_exception_with(col_floors[n])
#
#
#
#
#
#
#
#
#func _on_ColArea_body_shape_entered(_body_id, body, _body_shape, _local_shape):
#	if body.is_in_group("floor"):
#		if !col_floors.has(body):
#			col_floors.push_back(body)
#
#	elif body.is_in_group("wall"):
#		if !col_walls.has(body):
#			col_walls.push_back(body)
#
#	elif body.is_in_group("sprite"):
#		if !col_sprites.has(body):
#			col_sprites.push_back(body)
#
#func _on_ColArea_body_shape_exited(_body_id, body, _body_shape, _local_shape):
#	if body.is_in_group("floor"):
#		if col_floors.has(body):
#			col_floors.erase(body)
#
#	if body.is_in_group("wall"):
#		if col_walls.has(body):
#			col_walls.erase(body)
#
#	if body.is_in_group("sprite"):
#		if col_sprites.has(body):
#			col_sprites.erase(body)
#
#
#func _on_Area2D_body_exited(body):
#	pass # Replace with function body.


func _on_Area2D_body_exited(_body):
	pass # Replace with function body.
