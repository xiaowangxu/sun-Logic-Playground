extends MarginContainer

export(PackedScene) var Module : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var module = Module.instance()
	
	var additionalvec : Vector2 = Vector2.ZERO
	
	if module.PinBoarder & 1 :
		module.position.y = 4
		additionalvec.y += 4
	if module.PinBoarder & 4 :
		module.position.x = 4
		additionalvec.x += 4
		
	if module.PinBoarder & 2 :
		additionalvec.y += 4
	if module.PinBoarder & 8 :
		additionalvec.x += 4

	$HBoxContainer/ViewportContainer/Viewport.add_child(module)
	
	var modulesize : Vector2 = module.get_node("Area2D/CollisionShape2D").shape.extents * 2  + additionalvec
	
	$HBoxContainer/ViewportContainer.rect_min_size = modulesize
	$HBoxContainer/ViewportContainer.rect_size = modulesize
	$HBoxContainer/ViewportContainer/Viewport.size = modulesize
	
	#self.rect_min_size = modulesize
	pass # Replace with function body.