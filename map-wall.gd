extends StaticBody2D
#Use this script for straight walls, made using the shape SEGMENT.
export (Array, float) var heights = [1,0]
#for 2: A-top & B-top ... A-bottom & B-bottom    (square)
#for 3: A-top .... B .... A-down               (triangle)
#for 4: A-top .. B-top .. B-bottom .. A-bottom   (square)

export(String) var texture_path = "res://textures/wireframe64.png"
export var texture_repeat = Vector2(1,1) #Be sure to set texture_repeat at Import!
export var texture_rotate = 0
export var texture_offset = Vector2(0,0)

var points
var was_position
var was_zoom
export(bool) var bug_label = 0
var labels = []

var average_position = Vector2()
var average_height = 0
var spawn_shape_position #used for transferring shape positions for a clone being spawned by sector

onready var Col = $CollisionShape2D
onready var ColShape = $CollisionShape2D.shape
onready var ColShapeA = $CollisionShape2D.shape.a
onready var ColShapeB = $CollisionShape2D.shape.b

func _ready():
	if spawn_shape_position != null:
		var shape = SegmentShape2D.new()
		shape.a = spawn_shape_position[0]
		shape.b = spawn_shape_position[1]
		$CollisionShape2D.shape = shape
		
	
	if $CollisionShape2D.position != Vector2(0,0) or $CollisionShape2D.scale != Vector2(1,1) or $CollisionShape2D.rotation_degrees != 0:
		#print(">M I S T A K E: map-wall's ColShape2D position !=(0,0), scale !=(1,1), or rotation != 0. Do these with the StaticBody instead. At: ",points)
		#queue_free()
		position += $CollisionShape2D.position
		$CollisionShape2D.position = Vector2(0,0)
		scale *= $CollisionShape2D.scale
		$CollisionShape2D.scale = Vector2(1,1)
		rotation_degrees = $CollisionShape2D.rotation_degrees
		$CollisionShape2D.rotation_degrees = 0
	
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
	
	for n in heights.size():
		average_height += heights[n]
		if n == heights.size()-1:
			average_height /= heights.size()
		
		
	
		if bug_label:
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
	
	was_position = to_global(position) #Remove this line for refresh, walls actually where they are



func _process(_delta):
	if was_position != to_global(position): #Even tho meant to be static, very useful for editing in real time
		if heights.size() == 3:
			points = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.a)]
		else:
			points = [to_global($CollisionShape2D.shape.a), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.b), to_global($CollisionShape2D.shape.a)]
		
		average_position = points[0] + points[1]
		average_position = Vector2(average_position.x/points.size(), average_position.y/points.size()) #Used for Z_INDEX sorting in rendering
		
		was_position = to_global(position)
	
	
	if was_zoom != Worldconfig.zoom:
		for n in labels.size():
			if Worldconfig.zoom > 0:
				labels[n].rect_scale = (Vector2(1,1)/scale)
			else:
				labels[n].rect_scale = (Vector2(1,1)/scale)  *  Worldconfig.Camera2D.zoom
