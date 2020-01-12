extends NinePatchRect

func _ready():
	set_process(false)
	set_physics_process(false)
	pass

func is_Position_inside(position : Vector2) -> bool :
	var rect : Rect2 = self.get_global_rect()
	print(rect)
	return rect.has_point(position)
	pass
	
func is_Area_inside(rect2 : Rect2) -> bool:
	var rect : Rect2 = self.get_global_rect()
	return rect.encloses(rect2)
	pass