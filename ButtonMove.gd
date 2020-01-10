extends TextureButton

func _ready():
	set_process(false)
	set_physics_process(false)
	pass

func _on_NewModuleLayer_on_NewModule_drop(newmodulelist):
	GlobalData.ToolMode = "Move"
	self.pressed = true
	pass
