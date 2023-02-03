extends Node2D

func _physics_process(_delta):
	if Input.is_action_pressed("ply2_up"):
		position += Vector2(0,5).rotated(deg2rad(rotation_degrees))
	
	elif Input.is_action_pressed("ply2_down"):
		position -= Vector2(0,5).rotated(deg2rad(rotation_degrees))
	
	
	if Input.is_action_pressed("ply2_left"):
		if Input.is_action_pressed("ui_select"):
			position -= Vector2(5,0).rotated(deg2rad(rotation_degrees))
		else:
			rotation_degrees -= 5
	
	elif Input.is_action_pressed("ply2_right"):
		if Input.is_action_pressed("ui_select"):
			position += Vector2(5,0).rotated(deg2rad(rotation_degrees))
		else:
			rotation_degrees += 5
	
	
	$base.extraZ[0] = $wheel0.positionZ
	$base.extraZ[1] = $wheel1.positionZ
	$base.extraZ[2] = $wheel2.positionZ
	$base.extraZ[3] = $wheel3.positionZ
	
	var average = (to_global($base.points[0]) + to_global($base.points[1]))/2
	
	$base2.extraZ[0] = slope(
		Vector3(to_global($base2.points[0]).x, to_global($base2.points[0]).y,0), 
		Vector3(to_global($base.points[3]).x, to_global($base.points[3]).y, $base.heights[3] + $base.extraZ[3]), 
		Vector3(average.x, average.y, (($base.heights[0] + $base.extraZ[0]) + ($base.heights[1] + $base.extraZ[1]))/2 ),#############
		Vector3(to_global($base.points[2]).x, to_global($base.points[2]).y, $base.heights[2] + $base.extraZ[2]))
	
	average = (to_global($base.points[1]) + to_global($base.points[2]))/2
	
	$base2.extraZ[1] = slope(
		Vector3(to_global($base2.points[1]).x, to_global($base2.points[1]).y,0), 
		Vector3(to_global($base.points[0]).x, to_global($base.points[0]).y, $base.heights[0] + $base.extraZ[0]), 
		Vector3(average.x, average.y, (($base.heights[1] + $base.extraZ[1]) + ($base.heights[2] + $base.extraZ[2]))/2 ),#############
		Vector3(to_global($base.points[3]).x, to_global($base.points[3]).y, $base.heights[3] + $base.extraZ[3]))
	
	average = (to_global($base.points[3]) + to_global($base.points[0]))/2
	
	$base2.extraZ[2] = slope(
		Vector3(to_global($base2.points[2]).x, to_global($base2.points[2]).y,0), 
		Vector3(to_global($base.points[0]).x, to_global($base.points[0]).y, $base.heights[0] + $base.extraZ[0]),
		Vector3(to_global($base.points[1]).x, to_global($base.points[1]).y, $base.heights[1] + $base.extraZ[1]), 
		Vector3(average.x, average.y, (($base.heights[3] + $base.extraZ[3]) + ($base.heights[0] + $base.extraZ[0]))/2 ))#############
	
	#for n in Children:
	##for m in Children[n].extraZ:
	###Children[n].extraZ[m] = slope(Children[n].points[m], )
	###


#func theraot():
#	var new_height = slope(
#		Vector3(to_global(position).x, to_global(position).y,0), 
#		Vector3(col_floors[n].points[0].x, col_floors[n].points[0].y, col_floors[n].heights[0]), 
#		Vector3(col_floors[n].points[1].x, col_floors[n].points[1].y, col_floors[n].heights[1]), 
#		Vector3(col_floors[n].points[2].x, col_floors[n].points[2].y, col_floors[n].heights[2])) #+ margin


func slope(v0,v1,v2,v3):
	var normal = (v2 - v1).cross(v3 - v1).normalized()
	var dir = Vector3(0.0, 0.0, 1.0)
	var r = v0 + dir * ((v1.dot(normal)) - v0.dot(normal)) / dir.dot(normal)
	
	return r.z


