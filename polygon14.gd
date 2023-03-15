tool
extends StaticBody2D

export(Texture) var texture = preload("res://icon.png")
export(Array,Vector3) var polygon = []

func _ready():
	if !Engine.is_editor_hint():
		var thanks = []
		var col = CollisionPolygon2D.new()
		for n in polygon.size():
			thanks.push_back( to_global(Vector2(polygon[n].x, polygon[n].y)) )
		
		col.polygon = thanks
		call_deferred("add_child",col)

func _process(_delta):
	update()

func _draw():
	if Engine.is_editor_hint():
		for n in polygon.size():
			draw_line(to_global(Vector2(polygon[n].x, polygon[n].y)), to_global(Vector2(polygon[loop(n+1,polygon.size())].x, polygon[loop(n+1,polygon.size())].y)), Color(1,1,1))

func loop(to_check, array_size):
	if to_check < 0:
		to_check += array_size
	
	if to_check > array_size-1:
		to_check -= array_size
	
	
	if (to_check < 0) or (to_check > array_size-1):
		to_check = loop(to_check, array_size)
	
	return(to_check)
