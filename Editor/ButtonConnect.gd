extends TextureButton

export(NodePath) var ToolBoxNodePath : NodePath 

func _ready():
	set_process(false)
	set_physics_process(false)
	pass

func _on_ButtonConnect_toggled(button_pressed):
	if button_pressed :
		self.get_node(self.ToolBoxNodePath).hide()
	pass
