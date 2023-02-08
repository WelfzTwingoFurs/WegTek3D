extends Node2D

export var higfx = true

func _ready():
	if !higfx:
		for n in get_children():
			if n.is_in_group("higfx"):
				n.queue_free()
			
			for m in n.get_children():
				if m.is_in_group("higfx"):
					m.queue_free()
				
				for o in m.get_children():
					if o.is_in_group("higfx"):
						o.queue_free()
					
					for p in o.get_children():
						if p.is_in_group("higfx"):
							p.queue_free()
