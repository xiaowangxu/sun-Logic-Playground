extends MarginContainer

export(PackedScene) var Module : PackedScene
export(String) var Name : String = ""

signal on_ButtonAdd_Clicked(modulepackedscene, mouseposition)

func _ready():
	set_process(false)
	set_physics_process(false)
	
	self.connect("on_ButtonAdd_Clicked", self.get_node("/root/Playground/NewModuleLayer"), "on_ButtonAdd_clicked")
	
	var module = Module.instance()
	
	if self.Name != "" :
		$HBoxContainer/VBoxContainer/NameLabel.text = self.Name
		$HBoxContainer/VBoxContainer/NameLabel.visible = true
	else :
		$HBoxContainer/VBoxContainer/NameLabel.visible = false
	
	module.DragEnable = false
	
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
	pass

func _on_ViewportContainer_gui_input(event) :
	if event.is_action_pressed("mouse_left") :
		#print("left Mouse Clicked")
		self.get_tree().set_input_as_handled()
		#print(event.position)
		self.emit_signal("on_ButtonAdd_Clicked", self.Module, event.position)
	pass
