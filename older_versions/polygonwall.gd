extends StaticBody2D

onready var points = []
var was_position
var average_position = Vector2()

export var heights = [0,0,0]

export(bool) var bug_label = 0

func _ready():
	for n in $CollisionPolygon2D.polygon.size():
		points.append(to_global($CollisionPolygon2D.polygon[n]))
		
		average_position += points[n]
		if n == $CollisionPolygon2D.polygon.size()-1:
			average_position = Vector2(average_position.x/$CollisionPolygon2D.polygon.size(), average_position.y/$CollisionPolygon2D.polygon.size())
		
	was_position = position
	
	
	if $CollisionPolygon2D.position != Vector2(0,0):
		print("M I S T A K E: ColPol2D at incorrect position \n",points)
		$CollisionPolygon2D.position = Vector2(0,0)
	
#	if heights.size != $CollisionPolygon2D.polygon.size():
	if heights.size() < $CollisionPolygon2D.polygon.size():
		print("M I S T A K E: ColPol2D's heights smaller than polygon \n",points)
		queue_free()
	
	
	
	if bug_label:
		for n in points.size():
			var new_label = Label.new()
			
			new_label.set_position($CollisionPolygon2D.polygon[n])
			new_label.text = str(n)
			
			new_label.rect_scale = Vector2(1,1)/scale
			new_label.rect_rotation = -rotation_degrees
			add_child(new_label)
			labels.append(new_label)

var labels = []




func _process(_delta):
	for n in labels.size():
		if Worldconfig.zoom > 0:
			labels[n].rect_scale = (Vector2(1,1)/scale)
			#labels[n].rect_scale = (Vector2(float(2)/Worldconfig.zoom, float(2)/Worldconfig.zoom)/scale)
		else:
			labels[n].rect_scale = (Vector2(1,1)/scale)  *  Worldconfig.Camera2D.zoom
	
	if was_position != position:
		for n in $CollisionPolygon2D.polygon.size():
			points[n] = (to_global($CollisionPolygon2D.polygon[n]))
			
	#	was_points = points
