extends StaticBody2D
#Use this script for floors & ceilings to stand on & hit your head against. Don't use for walls.
export (Array, float) var heights = []
#for 1: all points = heights[0]
#for heights.size(): points = heights


export(String) var texture_path = "res://textures/gradsimple64.png"
export var texture_repeat = Vector2(1,1) #Be sure to set texture_repeat at Import!
export(float) var texture_rotate = 0
export var texture_offset = Vector2(0,0)

var points = []
var was_position
var was_zoom
export(bool) var bug_label = 0
var labels = []

var spawn_shape_position #used for transferring shape positions for a clone being spawned by sector

func _ready():
	if spawn_shape_position != null:
		$CollisionPolygon2D.polygon = spawn_shape_position
	
	if $CollisionPolygon2D.position != Vector2(0,0) or $CollisionPolygon2D.scale != Vector2(1,1) or $CollisionPolygon2D.rotation_degrees != 0:
		#print(">M I S T A K E: map-floor's ColPoly2D position !=(0,0), scale !=(1,1), or rotation != 0. Do these with the StaticBody instead. At: ",position)
		#queue_free()
		position += $CollisionPolygon2D.position
		$CollisionPolygon2D.position = Vector2(0,0)
		scale *= $CollisionPolygon2D.scale
		$CollisionPolygon2D.scale = Vector2(1,1)
		rotation_degrees = $CollisionPolygon2D.rotation_degrees
		$CollisionPolygon2D.rotation_degrees = 0
		
	
	if heights.size() != $CollisionPolygon2D.polygon.size():
		if heights.size() == 1:
			for n in $CollisionPolygon2D.polygon.size()-1:
				heights.append(heights[0])
		else:
			print(">M I S T A K E: map-floor's heights array size(",heights.size(),") doesn't match polygon size. Must be =1 or =polygon size. At: ",position)
			queue_free()
	
	################################################################################################################################################################
	
	
	for n in $CollisionPolygon2D.polygon.size():
		points.append(to_global($CollisionPolygon2D.polygon[n]))
		
		if bug_label:
			var new_label = Label.new()
			
			new_label.set_position($CollisionPolygon2D.polygon[n])
			new_label.text = str(n)
			
			new_label.rect_scale = Vector2(1,1)/scale
			new_label.rect_rotation = -rotation_degrees
			add_child(new_label)
			labels.append(new_label)
	
	#was_position = position




func _process(_delta):
	if was_position != to_global(position): #Even tho meant to be static, very useful for editing in real time
		for n in points.size():
			points[n] = (to_global($CollisionPolygon2D.polygon[n]))
			
		was_position = to_global(position)
		
	
	
	if was_zoom != Worldconfig.zoom:
		for n in labels.size():
			if Worldconfig.zoom > 0:
				labels[n].rect_scale = (Vector2(1,1)/scale)
			else:
				labels[n].rect_scale = (Vector2(1,1)/scale)  *  Worldconfig.Camera2D.zoom
