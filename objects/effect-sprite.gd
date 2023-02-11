extends KinematicBody2D

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

var daddy = null

func _ready():
	
	if anim > vframes*hframes:
		anim = 0
	
	if $CollisionShape2D.position != Vector2(0,0):
		position = to_global($CollisionShape2D.position)
		$CollisionShape2D.position = Vector2(0,0)


func _process(_delta):
	if daddy != null:
		position = daddy#.lightFT
		#positionZ = daddy.positionZ
		
		#position = Worldconfig.player.position







export var spr_height = 0
