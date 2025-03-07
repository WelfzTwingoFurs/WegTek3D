extends Camera2D
var fov = 120#@export
@export var drawdist = 8192
@export var position_z = 0

var nodes_z = []
var debugcount = Vector3()
func _draw():
################################### NEW STUFF!!! ###########################################
	draw_set_transform(Vector2i(),false,Vector2(1, 1))
	
	var Ymax = (300-get_parent().position_z)/29.4/ 0.0001 *DisplayServer.window_get_size().x/1225.0
	var Ymin = (300-get_parent().position_z)/29.4/ 4.0960 *DisplayServer.window_get_size().x/1225.0
	
	var rot = $Area.rotation_degrees/360.0 * DisplayServer.window_get_size().x
	
	draw_colored_polygon(PackedVector2Array(
		[Vector2(-rot+DisplayServer.window_get_size().x*1.5,Ymax),#low right #destroys angle: DisplayServer.window_get_size().x/2
		Vector2( -rot-DisplayServer.window_get_size().x/2,Ymax),#low left
		Vector2( -rot-DisplayServer.window_get_size().x/2,Ymin),#high left
		Vector2( -rot+DisplayServer.window_get_size().x*1.5,Ymin)]),#high right
		Color(1,1,1,1), PackedVector2Array([Vector2(), Vector2(1,0), Vector2(1,1600), Vector2(0,1600)]), load("res://resources/floor.png"))
	############################ FLOOR !!!!! ###############################################
	########################################################################################
	
	
	
	for objects in sky: if typeof(objects) == TYPE_ARRAY: 
		if sign(get_parent().position_z-300) == sign(objects[1]): continue
		
		var Y = 0
		if objects[1] != 0:#stretch sky
			var thing = DisplayServer.window_get_size().x/float(objects[0].get_width())/objects[1]
			draw_set_transform(Vector2i(),false,Vector2(abs(thing),thing))
			Y = (objects[2] * DisplayServer.window_get_size().x/1225.0)/thing -objects[0].get_height()
			for t in abs(objects[1])+1:#loop to complete horizon horizontally
				draw_texture(objects[0],
				Vector2(-$Area.rotation_degrees * objects[0].get_width()/360.0 -objects[0].get_width()*t +objects[0].get_width()*abs(objects[1])/2, Y))
			
		
		else:#non-stretched sky
			draw_set_transform(Vector2i(),false,Vector2(1,1))
			Y = (objects[2] * DisplayServer.window_get_size().x/1225.0) -objects[0].get_height()
			for t in (DisplayServer.window_get_size().x/objects[0].get_width())*2:#loop to complete horizon horizontally
				draw_texture(objects[0],
				Vector2(-$Area.rotation_degrees * objects[0].get_width()/360.0 -objects[0].get_width()*t +DisplayServer.window_get_size().x/2, Y))
			
	################################################################################################
	#################################################################################################
	#################################################################################################
	
	#################################################################################################
	
	#################################################################################################
	
	#################################################################################################
	
	#################################################################################################
	
	#################################################################################################
	#################################################################################################
	################################################################################################
	var midscreen = Vector2(0,1).rotated($Area.rotation).angle()
	var drawlist = []
	
	for object in inview:#what do we see?
		if object.get_type(): for poly in object.poly_faces:#get_type() == true == polygon array. How many polys in array?
			var current = []
			var z_calc = 0
			
			var behind_count = 0
			for n in poly:#n(vertex/info), of poly(current polygon), of object.poly_faces(list in poly), of object(model in world)
				if typeof(n) == TYPE_INT:#INT? Means it's vertex! Calculating...
					draw_set_transform(Vector2i(),false, Vector2(1,1))
					var vertex2 = (Vector2(object.poly_verts[n].x, object.poly_verts[n].y) *object.scale) +object.position
					var angle = (vertex2-global_position).angle() - midscreen
					
					var final = Vector2(
						tan(angle),
						((object.position_z+object.poly_verts[n].z*object.scale_z)-(get_parent().position_z - position_z))/29.4  /  (global_position.distance_to(vertex2)/10000 * cos(angle))
						) * Vector2(# 90/2 =45 || 100/2.38 =42.01 || 120/3.5 =34.28 || 130/4.28 =30.37 || 170/22.85 = 7.43
						DisplayServer.window_get_size().x/3.6,#3.5 for 120 fov...
						DisplayServer.window_get_size().x/1225.0)#1225 = 35*35
					
					behind_count += 1
					if global_position.distance_to(vertex2) * cos(angle) < 0:#Behind fix 
						final = Vector2(100000000,0).rotated((-final-Vector2(midscreen,0)).angle())
						z_calc += drawdist
						behind_count -= 1
					else: z_calc += Vector3(global_position.x, global_position.y, (get_parent().position_z - position_z)).distance_to(object.poly_verts[n] + Vector3(object.position.x, object.position.y, object.position_z))
					
					current.append(final)
					debugcount.z += 1
				
				#Not INT? Means it's polygon info! Drawing...
				elif Geometry2D.triangulate_polygon(current) && Geometry2D.is_polygon_clockwise(current) && behind_count:
					
					if typeof(n) == TYPE_COLOR:#draw_colored_polygon
						drawlist.append([z_calc/poly.size(), current, n])#polygon color, no texture]
					else:#polygon colored texture
						drawlist.append([z_calc/poly.size(), current, poly[poly.size()-1], select_uv(current.size()), n])
					
					debugcount.y += 1#
					break
				
				else:break
				#debugcount.y += 1
		
		
		
		else:#object.get_type() == Sprite:
			var sprite
			var rotangle = 1
			if object.rotations == 1: sprite = load(str("res://resources/",object.texture,".png"))
			
			elif object.rotations > 1:
				rotangle = (-int(( ($Area.rotation_degrees-(object.rotation_degrees+180))/360 )*(abs(object.rotations)+1)) % 360) % object.rotations
				
				if rotangle < 0: rotangle = object.rotations+rotangle#all rotations
				sprite = load(str("res://resources/",object.texture, rotangle,".png"))
				rotangle = -1
			
			
			elif object.rotations < -1:
				rotangle = (int(( ($Area.rotation_degrees-(object.rotation_degrees+180))/360 )*(abs(object.rotations)+1)) % 360)# % object.rotations/2
				print(rotangle," ",object.rotations)
				
				if rotangle < object.rotations/2:
					rotangle -= object.rotations
					print(rotangle)
				
				if (rotangle < 0) or (!object.rot_flip && (rotangle == -object.rotations/2)): 
					rotangle = abs(rotangle)#for flipped graphics
					sprite = load(str("res://resources/",object.texture, rotangle,".png"))
					rotangle = -1
					
				
				#elif rotangle > -object.rotations/2:
				#	rotangle += object.rotations
				#	print(rotangle)
				#	sprite = load(str("res://resources/",object.texture, abs(rotangle),".png"))
				#	if object.rot_flip && ((rotangle == 0) or (rotangle == -object.rotations/2)): 
				#		rotangle = -1
				#		print(rotangle)
				
				else:
					sprite = load(str("res://resources/",object.texture, abs(rotangle),".png"))
					#print($Area.rotation_degrees-object.rotation_degrees)
					#if rotangle == 0: rotangle = 1
					#elif (object.rot_flip && (rotangle == -object.rotations/2) && ($Area.rotation_degrees-object.rotation_degrees > 360)): rotangle = -1
				
				if rotangle == 0:
					if object.rot_flip && ($Area.rotation_degrees-object.rotation_degrees > 180): rotangle = -1
					else: rotangle = 1
			
			
			var angle = (object.global_position-global_position).angle() - midscreen
			var size = digit_to_decimal(8192-sprite.get_size().x)*object.scale_z / ((global_position.distance_to(object.global_position)/(DisplayServer.window_get_size().x)) * cos(angle))
			
			if size > 0:
				drawlist.append(
				[Vector3(global_position.x, global_position.y, (get_parent().position_z - position_z)).distance_to(Vector3i(object.global_position.x, object.global_position.y, object.position_z)),
				sprite, (Vector2(
					tan(angle),
					(object.position_z-(get_parent().position_z - position_z))/29.4  /  (global_position.distance_to(object.global_position)/8192 * cos(angle))
					) * Vector2(
						(DisplayServer.window_get_size().x/3.6)*sign(rotangle),
						DisplayServer.window_get_size().x/1225.0)/size)
						- Vector2(
							sprite.get_size().x/2,
							sprite.get_size().y/(2*int(!object.offset_z) + 1*int(object.offset_z))),# Offset correction
					object.modulate, size*sign(rotangle)])
				
				debugcount.x += 1
	
	
	
	
	
	
	#organize drawing order and draw!
	drawlist.sort_custom(sort_ascending)
	
	for X in drawlist:
		if typeof(X[1]) == TYPE_OBJECT:#Received texture, is sprite!
			draw_set_transform(Vector2i(),false, Vector2(X[4],abs(X[4])))
			draw_texture(X[1], X[2], X[3]) 
		
		elif typeof(X[2]) == TYPE_COLOR:#Received color, is polygon!
			draw_set_transform(Vector2i(),false, Vector2(1,1))
			if X.size() == 3: draw_colored_polygon(X[1], X[2])#flat polygon! 
			else: draw_colored_polygon(X[1], X[2], X[3], load(X[4]))#textured polygon!
	#################################################################################################
	#################################################################################################
	#################################################################################################
	
	#################################################################################################
	
	#################################################################################################
	
	#################################################################################################
	
	#################################################################################################
	#################################################################################################
	#################################################################################################
	draw_set_transform(Vector2i(),false, Vector2(1,1))
	var drawstring = str(
		"(x",int(global_position.x)," y",int(global_position.y)," z",int((get_parent().position_z - position_z))," r",int($Area.rotation_degrees),") *",Engine.time_scale,"\n",
		inview.size()," objects, ",debugcount.x+debugcount.z," points (", debugcount.z," vertexes, ",debugcount.x," sprites, ",debugcount.y," polygons)",
		"\nFPS: ",Engine.get_frames_per_second()#," x ",get_parent().framehack
		)
	debugcount = Vector3()
	
	var count = 1
	for L in drawstring.split("\n"):
		draw_string(ThemeDB.fallback_font, Vector2(-DisplayServer.window_get_size().x/2, offset.y+(15*count)-DisplayServer.window_get_size().y/2), L)
		count += 1
	#DRAW TEXT
	
	################################################################################################
	################################################################################################
	
	
	
	
	
	
	
	
	
	
	



func sort_ascending(a, b):
	if a[0] > b[0]:
		return true
	return false
# Render


















####################################################################################################
####################################################################################################
func zindex_max(n):#replace this with % 8192 later
	if n < -4096: return -4096
	elif n > 4096: return 4096
	return n

func digit_to_decimal(n):
	while n > 1: n /= 10
	return n

func select_uv(n):
	if n == 3: return PackedVector2Array([Vector2(0,0), Vector2(1,0), Vector2(1,1)])
	elif n == 4: return PackedVector2Array([Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)])
	return PackedVector2Array()

####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
var inview = []
func _on_area_body_entered(body): if body.is_in_group("render"): inview.push_back(body)
func _on_area_body_exited(body): inview.erase(body)
####################################################################################################
####################################################################################################

var sky = []
var valuecompare = -1
func _process(_delta):#Graphics process exclusively
	if $Area.rotation_degrees < 0: $Area.rotation_degrees += 360 #if ($Area.rotation_degrees < 0) or ($Area.rotation_degrees > 360): $Area.rotation_degrees = int($Area.rotation_degrees) % 360
	elif $Area.rotation_degrees > 360: $Area.rotation_degrees -= 360
	################################################################################################
	
	################################################################################################
	if drawdist-fov != valuecompare:#Reconfiguration, y'know so we don't run this every frame
		if drawdist < 1: drawdist = 1
		#elif drawdist > 8192: drawdist = 8192#NOT NECESSARY ANYMORE!
		if fov < 2: fov = 2
		elif fov > 178: fov = 178
		valuecompare = drawdist-fov
		
		var B2 = Vector2(0,1).rotated(deg_to_rad(fov/2.0))
		$Area/Col.polygon[1] = Vector2(drawdist*B2.x/B2.y, drawdist*B2.y/B2.y)
		$Area/Col.polygon[2] = Vector2(-1,1) * $Area/Col.polygon[1]
	################################################################################################
	
	################################################################################################
	sky = [$Area.rotation_degrees, #SKY & FLOOR
	#TEXTURE, DIVIDE SCALE, (HEIGHT<xxx>DISTANCE BULLSHIT)
		[load("res://resources/sky3.png"),  3.0,( 200-(get_parent().position_z - position_z))/29.4/ 4.9152],
		[load("res://resources/sky2.png"),  2.5,( 100-(get_parent().position_z - position_z))/29.4/ 4.0960],
		[load("res://resources/sky1.png"),  2.0,( 200-(get_parent().position_z - position_z))/29.4/ 3.2768],
		[load("res://resources/sky0.png"),  1.5,( 300-(get_parent().position_z - position_z))/29.4/ 1.6384],
		[load("res://resources/cave0.png"),-1.5,( 600-(get_parent().position_z - position_z))/29.4/ 4.0960],
		[load("res://resources/cave0.png"),-1.0,( 300-(get_parent().position_z - position_z))/29.4/ 3.2768],
		]
	################################################################################################
	
	################################################################################################
	queue_redraw()
