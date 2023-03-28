extends KinematicBody2D

var flip_frontback = false
var spr_height = 0
export var positionZ = 0
var anim = 0
var scale_extra = Vector2(2,2)
export(Texture) var texture = preload("res://assets/sprites ped0a.png")
var vframes = 1
var hframes = 1
var rotations = 1
var darkness = 1
var dynamic_darkness = true
var dontScale = -1
var dontZ = false
var stepover = false
var shadow = false

var vbob = 0

func _physics_process(_delta):
	spr_height = abs(vbob)
	
	vbob += 1
	
	if vbob > 10:
		vbob = -10

func _on_Area2D_body_entered(body):
	add_collision_exception_with(body)
