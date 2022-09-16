extends StaticBody2D

onready var points = []
export var heights = [0,0,0]

var was_position
var was_zoom
export(bool) var bug_label = 0
var labels = []

var average_position = Vector2()

func _ready():
	for n in $CollisionPolygon2D.polygon.size():
		points.append(to_global($CollisionPolygon2D.polygon[n]))
	was_position = position
	
	
	if $CollisionPolygon2D.position != Vector2(0,0):
		print(">M I S T A K E: ColPol2D at incorrect position. At: ",points)
		$CollisionPolygon2D.position = Vector2(0,0)
	
#	if heights.size != $CollisionPolygon2D.polygon.size():
	if heights.size() < $CollisionPolygon2D.polygon.size():
		print(">M I S T A K E: Polywall's heights smaller than polygon. At: ",points)
		queue_free()
	
	
	for n in points.size():
		average_position += points[n]
		if n == points.size()-1:
			average_position = Vector2(average_position.x/points.size(), average_position.y/points.size())
		
		
		
		if bug_label:
			var new_label = Label.new()
			
			new_label.set_position($CollisionPolygon2D.polygon[n])
			new_label.text = str(n)
			
			new_label.rect_scale = Vector2(1,1)/scale
			new_label.rect_rotation = -rotation_degrees
			add_child(new_label)
			labels.append(new_label)
		




func _process(_delta):
	if was_position != position: #Even tho meant to be static, very useful for editing in real time
		for n in points.size():
			points[n] = (to_global($CollisionPolygon2D.polygon[n]))
			
	
	
	
	if was_zoom != Worldconfig.zoom:
		for n in labels.size():
			if Worldconfig.zoom > 0:
				labels[n].rect_scale = (Vector2(1,1)/scale)
			else:
				labels[n].rect_scale = (Vector2(1,1)/scale)  *  Worldconfig.Camera2D.zoom
