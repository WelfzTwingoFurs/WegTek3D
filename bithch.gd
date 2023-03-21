tool
extends Sprite

func _process(delta):
	if Engine.is_editor_hint():
		rotation_degrees += 1 * delta
