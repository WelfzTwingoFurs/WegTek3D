extends StaticBody2D

onready var points = []
var was_position

export var heights = [0,0,0]

export(bool) var bug_label = 0

func _ready():
	for n in $CollisionPolygon2D.polygon.size():
		points.append(to_global($CollisionPolygon2D.polygon[n]))
	was_position = position
	
	
	if $CollisionPolygon2D.position != Vector2(0,0):
		print("M I S T A K E: ColPol2D at incorrect position \n",points)
		$CollisionPolygon2D.position = Vector2(0,0)
	
#	if heights.size != $CollisionPolygon2D.polygon.size():
	if heights.size() < $CollisionPolygon2D.polygon.size():
		print("M I S T A K E: ColPol2D's heights smaller than polygon \n",points)
	
	
	
	if bug_label:
		for n in points.size():
			var new_label = Label.new()
			
			new_label.set_position($CollisionPolygon2D.polygon[n])
			new_label.text = str(n)
			
			new_label.rect_scale = Vector2(1,1)/scale
			new_label.rect_rotation = -rotation_degrees
			add_child(new_label)






func _process(_delta):
	if was_position != position:
		for n in $CollisionPolygon2D.polygon.size():
			points[n] = (to_global($CollisionPolygon2D.polygon[n]))
			
	#	was_points = points
