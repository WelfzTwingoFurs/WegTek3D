extends KinematicBody2D

onready var points = []
export var heights = [0,0,0]

#var was_position
#var was_zoom
export(bool) var bug_label = 0
var labels = []

var average_position = Vector2()


var motion = Vector2()

export var rotation_angle = -1
export var speed = -1
export var rate = -1


func _ready():
	for n in $CollisionPolygon2D.polygon.size():
		points.append(to_global($CollisionPolygon2D.polygon[n]))
	
	
	if $CollisionPolygon2D.position != Vector2(0,0):
		print(">M I S T A K E: ColPol2D at incorrect position. At: ",points)
		$CollisionPolygon2D.position = Vector2(0,0)
	
#	if heights.size != $CollisionPolygon2D.polygon.size():
	if heights.size() < $CollisionPolygon2D.polygon.size():
		print(">M I S T A K E: Polywall's heights smaller than polygon. At: ",points)
		queue_free()
	
	
	
	if bug_label:
		for n in points.size():
			var new_label = Label.new()
			
			new_label.set_position($CollisionPolygon2D.polygon[n])
			new_label.text = str(n)
			
			new_label.rect_scale = Vector2(1,1)/scale
			#new_label.rect_rotation = -rotation_degrees
			add_child(new_label)
			labels.append(new_label)
	
	
	
	
	if rotation_angle == -1:
		rotation_angle = rad_deg((randi() % 361))
	
	if speed == -1:
		speed = randi() % 50
	
	if rate == -1:
		rate = 1 + (randi() % 10)




func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	motion = Vector2(speed, speed).rotated(rotation_angle)*Engine.time_scale
	
	rotation_angle -= (0.0174533 * rate)*Engine.time_scale
	
	if rotation_angle < 0:
		rotation_angle = 2*PI #360 in radian
	
	rotation_degrees = rad_deg(rotation_angle)
	
	
	for n in points.size():
		points[n] = (to_global($CollisionPolygon2D.polygon[n]))
		
		average_position += points[n]
		if n == points.size()-1:
			average_position = Vector2(average_position.x/points.size(), average_position.y/points.size())
		
		
		
		labels[n].rect_rotation = -rotation_degrees
		
		if Worldconfig.zoom > 0:
			labels[n].rect_scale = (Vector2(1,1)/scale)
		else:
			labels[n].rect_scale = (Vector2(1,1)/scale)  *  Worldconfig.Camera2D.zoom






func rad_deg(N):
	N *= 180/PI
	return N

func deg_rad(N):
	N *= PI/180
	return N
