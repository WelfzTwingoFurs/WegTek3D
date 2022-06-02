extends KinematicBody2D

var motion = Vector2()

export var rotation_angle = -1

export var speed = -1

export var rate = -1

func _ready():
	if rotation_angle == -1:
		rotation_angle = rad_deg((randi() % 361))
	
	if speed == -1:
		speed = randi() % 50
	
	if rate == -1:
		rate = 1 + (randi() % 10)


func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = Vector2(speed, speed).rotated(rotation_angle)
	
	rotation_angle -= 0.0174533 * rate
	
	if rotation_angle < 0:
		rotation_angle = 2*PI #360 in radian
	
	
	rotation_degrees = rad_deg(rotation_angle)








func rad_deg(N):
	N *= 180/PI
	return N

func deg_rad(N):
	N *= PI/180
	return N
