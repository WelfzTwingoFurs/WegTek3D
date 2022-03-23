extends KinematicBody2D

onready var RayCast2D = $RayCast2D

var motion = Vector2()
const SPEED = 100


func _physics_process(_delta):
	motion = move_and_slide(motion, Vector2(0,-1))
	
	
	if Input.is_action_pressed("ui_up"):
		motion = Vector2(0, SPEED).rotated(rotate)
	
	elif Input.is_action_pressed("ui_down"):
		motion = Vector2(0, -SPEED).rotated(rotate)
	
	else:
		motion = Vector2(0,0)
	
	
	if Input.is_action_pressed("ui_left"):
		rotate -= 0.01
		
		if rotate < 0:
			rotate = 6.28
		
	
	elif Input.is_action_pressed("ui_right"):
		rotate += 0.01
		
		if rotate > 6.28:
			rotate = 0
		
	
	if Input.is_action_pressed("ui_accept"):
		$RayCast2D.visible = 1
		$RayCast2D2.visible = 1
	else:
		$RayCast2D.visible = 0
		$RayCast2D2.visible = 0
	
	update()
	


var rotate = 3.14
var rotate_plus = 0



func _draw():
	RayCast2D.rotation_degrees = (rotate * 180 / 3.14) + (rotate_plus  * 180 / 3.14)
	$RayCast2D2.rotation_degrees = (rotate * 180 / 3.14)
	
	var distance = sqrt(pow(RayCast2D.get_collision_point().x - position.x, 2) + pow(RayCast2D.get_collision_point().y - position.y, 2))#get position
	
	#print(distance)
	
	if rotate_plus > 0.78:
		rotate_plus = -0.78
		plus_distance_cycle = 0
		
	else:
		rotate_plus += 0.1
		plus_distance_cycle += 1
		
		if (distance-100) < 150:#  &&  (distance-400) > 150:
			plus_distance[plus_distance_cycle].y = distance-100
		else:
			plus_distance[plus_distance_cycle].y = 150
			
		
		
		plus_distance[plus_distance_cycle].x = rotate_plus*300
		
	
	
	
	
	
#
#	for i in range(0, len(plus_distance), 2):
#		if i < len(plus_distance) - 1:
#			draw_line(Vector2(plus_distance[plus_distance_cycle].x, plus_distance[i].y),
#				  Vector2(plus_distance[i].x, 300-plus_distance[i].y), Color8(255, 255, 0), 1)
#
#			draw_line(Vector2(plus_distance[i].x, plus_distance[i].y),
#					  Vector2(plus_distance[i+1].x, plus_distance[i+1].y), Color8(0, 0, 255), 1)
#			draw_line(Vector2(plus_distance[i].x, 300-plus_distance[i].y),
#					  Vector2(plus_distance[i+1].x, 300-plus_distance[i+1].y), Color8(0, 0, 255), 1)
	
	
#	draw_line(Vector2(plus_distance[1].x, plus_distance[1].y),
#			  Vector2(plus_distance[1].x, 300-plus_distance[1].y), Color8(255, 255, 0), 1)

#	draw_line(Vector2(plus_distance[1].x, plus_distance[1].y),
#			  Vector2(plus_distance[2].x, plus_distance[2].y), Color8(0, 0, 255), 1)
#	draw_line(Vector2(plus_distance[1].x, 300-plus_distance[1].y),
#			  Vector2(plus_distance[2].x, 300-plus_distance[2].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[2].x, plus_distance[2].y),
			  Vector2(plus_distance[2].x, 300-plus_distance[2].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[2].x, plus_distance[2].y),
			  Vector2(plus_distance[3].x, plus_distance[3].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[2].x, 300-plus_distance[2].y),
			  Vector2(plus_distance[3].x, 300-plus_distance[3].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[3].x, plus_distance[3].y),
			  Vector2(plus_distance[3].x, 300-plus_distance[3].y), Color8(255, 255, 0), 1)

	

	draw_line(Vector2(plus_distance[3].x, plus_distance[3].y),
			  Vector2(plus_distance[4].x, plus_distance[4].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[3].x, 300-plus_distance[3].y),
			  Vector2(plus_distance[4].x, 300-plus_distance[4].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[4].x, plus_distance[4].y),
			  Vector2(plus_distance[4].x, 300-plus_distance[4].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[4].x, plus_distance[4].y),
			  Vector2(plus_distance[5].x, plus_distance[5].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[4].x, 300-plus_distance[4].y),
			  Vector2(plus_distance[5].x, 300-plus_distance[5].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[5].x, plus_distance[5].y),
			  Vector2(plus_distance[5].x, 300-plus_distance[5].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[5].x, plus_distance[5].y),
			  Vector2(plus_distance[6].x, plus_distance[6].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[5].x, 300-plus_distance[5].y),
			  Vector2(plus_distance[6].x, 300-plus_distance[6].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[6].x, plus_distance[6].y),
			  Vector2(plus_distance[6].x, 300-plus_distance[6].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[6].x, plus_distance[6].y),
			  Vector2(plus_distance[7].x, plus_distance[7].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[6].x, 300-plus_distance[6].y),
			  Vector2(plus_distance[7].x, 300-plus_distance[7].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[7].x, plus_distance[7].y),
			  Vector2(plus_distance[7].x, 300-plus_distance[7].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[7].x, plus_distance[7].y),
			  Vector2(plus_distance[8].x, plus_distance[8].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[7].x, 300-plus_distance[7].y),
			  Vector2(plus_distance[8].x, 300-plus_distance[8].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[8].x, plus_distance[8].y),
			  Vector2(plus_distance[8].x, 300-plus_distance[8].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[8].x, plus_distance[8].y),
			  Vector2(plus_distance[9].x, plus_distance[9].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[8].x, 300-plus_distance[8].y),
			  Vector2(plus_distance[9].x, 300-plus_distance[9].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[9].x, plus_distance[9].y),
			  Vector2(plus_distance[9].x, 300-plus_distance[9].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[9].x, plus_distance[9].y),
			  Vector2(plus_distance[10].x, plus_distance[10].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[9].x, 300-plus_distance[9].y),
			  Vector2(plus_distance[10].x, 300-plus_distance[10].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[10].x, plus_distance[10].y),
			  Vector2(plus_distance[10].x, 300-plus_distance[10].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[10].x, plus_distance[10].y),
			  Vector2(plus_distance[11].x, plus_distance[11].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[10].x, 300-plus_distance[10].y),
			  Vector2(plus_distance[11].x, 300-plus_distance[11].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[11].x, plus_distance[11].y),
			  Vector2(plus_distance[11].x, 300-plus_distance[11].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[11].x, plus_distance[11].y),
			  Vector2(plus_distance[12].x, plus_distance[12].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[11].x, 300-plus_distance[11].y),
			  Vector2(plus_distance[12].x, 300-plus_distance[12].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[12].x, plus_distance[12].y),
			  Vector2(plus_distance[12].x, 300-plus_distance[12].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[12].x, plus_distance[12].y),
			  Vector2(plus_distance[13].x, plus_distance[13].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[12].x, 300-plus_distance[12].y),
			  Vector2(plus_distance[13].x, 300-plus_distance[13].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[13].x, plus_distance[13].y),
			  Vector2(plus_distance[13].x, 300-plus_distance[13].y), Color8(255, 255, 0), 1)

	draw_line(Vector2(plus_distance[13].x, plus_distance[13].y),
			  Vector2(plus_distance[14].x, plus_distance[14].y), Color8(0, 0, 255), 1)
	draw_line(Vector2(plus_distance[13].x, 300-plus_distance[13].y),
			  Vector2(plus_distance[14].x, 300-plus_distance[14].y), Color8(0, 0, 255), 1)

	draw_line(Vector2(plus_distance[14].x, plus_distance[14].y),
			  Vector2(plus_distance[14].x, 300-plus_distance[14].y), Color8(255, 255, 0), 1)
	
	
	
#		draw_line(Vector2(plus_distance[plus_distance_cycle].x, plus_distance[plus_distance_cycle].y),
#			  Vector2(plus_distance[plus_distance_cycle].x, 300-plus_distance[plus_distance_cycle].y), Color8(255, 255, 0), 1)
#
#	draw_line(Vector2(plus_distance[plus_distance_cycle].x, plus_distance[plus_distance_cycle].y),
#			  Vector2(plus_distance[plus_distance_cycle+1].x, plus_distance[plus_distance_cycle+1].y), Color8(0, 0, 255), 1)
#	draw_line(Vector2(plus_distance[plus_distance_cycle].x, 300-plus_distance[plus_distance_cycle].y),
#			  Vector2(plus_distance[plus_distance_cycle+1].x, 300-plus_distance[plus_distance_cycle+1].y), Color8(0, 0, 255), 1)
	
	
	


var plus_distance = [Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2(),Vector2()]
var plus_distance_cycle = 0











#		draw_line(Vector2(plus_distance[plus_distance_cycle].x*100, plus_distance[plus_distance_cycle].y-100),
#			  Vector2(plus_distance[plus_distance_cycle].x*100, 300-plus_distance[plus_distance_cycle].y-100), Color8(255, 255, 0), 1)
	
	#draw_line(Vector2(rotate_plus*100, distance-100), Vector2(rotate_plus*100, 300-distance-100), Color8(255, 255, 0), 1)



#onready var rays = $rays
#onready var ray1 = $rays/ray1
#onready var ray2 = $rays/ray2
#onready var ray3 = $rays/ray3
#onready var ray4 = $rays/ray4
#onready var ray5 = $rays/ray5


#rays.rotation_degrees = (rotate * 180 / 3.14) + (rotate_plus  * 180 / 3.14)

#func draw_wall():
	#var ray_hit = RayCast2D.get_collision_point()
	#distance = sqrt(pow(ray_hit.x - position.x, 2) + pow(ray_hit.y - position.y, 2))#get position

#func _draw():
#	draw_line(Vector2(0,0), Vector2(0, 100-distance1), Color8(255, 255, 0)/3, 1)

#var distance1 = 10
#var distance2 = 10
#var distance3 = 10
#var distance4 = 10
#var distance5 = 10
#
#func _draw():
#	print(distance1)
#
#	distance1 = sqrt(pow(ray1.get_collision_point().x - position.x, 2) + pow(ray1.get_collision_point().y - position.y, 2))
#	if distance1 < 150:
#		draw_line(Vector2(-30,distance1), Vector2(-30, 300-distance1), Color8(255, 255, 0)/3, 1)
#
#	distance2 = sqrt(pow(ray2.get_collision_point().x - position.x, 2) + pow(ray2.get_collision_point().y - position.y, 2))
#	if distance2 < 150:
#		draw_line(Vector2(-15,distance2), Vector2(-15, 300-distance2), Color8(255, 255, 0)/3, 1)
#
#	distance3 = sqrt(pow(ray3.get_collision_point().x - position.x, 2) + pow(ray3.get_collision_point().y - position.y, 2))
#	if distance3 < 150:
#		draw_line(Vector2(0,distance3), Vector2(0, 300-distance3), Color8(255, 255, 0)/3, 1)
#
#	distance4 = sqrt(pow(ray4.get_collision_point().x - position.x, 2) + pow(ray4.get_collision_point().y - position.y, 2))
#	if distance4 < 150:
#		draw_line(Vector2(15,distance4), Vector2(15, 300-distance4), Color8(255, 255, 0)/3, 1)
#
#	distance5 = sqrt(pow(ray5.get_collision_point().x - position.x, 2) + pow(ray5.get_collision_point().y - position.y, 2))
#	if distance5 < 150:
#		draw_line(Vector2(30,distance5), Vector2(30, 300-distance5), Color8(255, 255, 0)/3, 1)
