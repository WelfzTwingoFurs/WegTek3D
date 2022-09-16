extends StaticBody2D
#Use this script for straight walls, made using the shape SEGMENT.
export (Array, float) var heights = [1,0]
#for 2: A-top & B-top ... A-bottom & B-bottom    (square)
#for 3: A-top .... B .... A-down               (triangle)
#for 4: A-top .. B-top .. B-bottom .. A-bottom   (square)

export(String) var texture_path = "res://textures/wireframe64.png"
export var texture_repeat = Vector2(1,1) #Be sure to set texture_repeat at Import!
export var texture_rotate = 0

var points
var was_position
var was_zoom
export(bool) var bug_label = 0
var labels = []

var average_position = Vector2()
var spawn_shape_position #used for transferring shape positions for a clone being spawned by sector

func _ready():
		#point_in_the_middle(x=(x1+x2)/2,y=(y1+y2)/2)
		#position = to_global(Vector2((spawn_shape_position[0].x + spawn_shape_position[1].x)/2, (spawn_shape_position[0].y + spawn_shape_position[1].y)/2))
	if spawn_shape_position != null:
		#$CollisionShape2D.shape.a = spawn_shape_position[0]
		#$CollisionShape2D.shape.b = spawn_shape_position[1]
		$CollisionShape2D.shape.set_a(spawn_shape_position[0])
		$CollisionShape2D.shape.set_b(spawn_shape_position[1])
		texture_path = "res://textures/gradsimple64.png"
	
	if $CollisionShape2D.position != Vector2(0,0) or $CollisionShape2D.scale != Vector2(1,1) or $CollisionShape2D.rotation_degrees != 0:
		print(">M I S T A K E: map-wall's ColShape2D position !=(0,0), scale !=(1,1), or rotation != 0. Do these with the StaticBody instead. At: ",points)
		queue_free()
	
	if heights.size() < 2 or heights.size() > 4:#or heights.size() == 3
		print(">M I S T A K E: map-wall's heights array size(",heights.size(),") <2, or >4. Must be =2 or =4. At: ",points)
		queue_free()
	
	################################################################################################################################################################
	
	if heights.size() == 2:
		heights.resize(4)
		heights[2] = heights[1]
		heights[3] = heights[1]
		heights[1] = heights[0]
	
	if heights.size() == 3:
		points = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.a)]
	else:
		points = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.a)]
	
	average_position = points[0] + points[1]
	average_position = Vector2(average_position.x/2, average_position.y/2) #Used for Z_INDEX sorting in rendering
	
	
	if bug_label:
		for n in heights.size():
			var new_label = Label.new()
			
			new_label.set_position(points[n]-position)
			if n < 2:
				new_label.text = str(n)
			else:
				new_label.text = str("  ,",n)
			
			new_label.rect_scale = Vector2(1,1)/scale
			new_label.rect_rotation = -rotation_degrees
			add_child(new_label)
			labels.append(new_label)
	
	was_position = position



func _process(_delta):
	if was_position != position: #Even tho meant to be static, very useful for editing in real time
		if heights.size() == 3:
			points = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.a)]
		else:
			points = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.a)]
		
		average_position = points[0] + points[1]
		average_position = Vector2(average_position.x/points.size(), average_position.y/points.size()) #Used for Z_INDEX sorting in rendering
	
	if was_zoom != Worldconfig.zoom:
		for n in labels.size():
			if Worldconfig.zoom > 0:
				labels[n].rect_scale = (Vector2(1,1)/scale)
			else:
				labels[n].rect_scale = (Vector2(1,1)/scale)  *  Worldconfig.Camera2D.zoom
