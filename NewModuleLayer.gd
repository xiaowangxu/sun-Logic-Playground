extends CanvasLayer

var NewModule : Module = null
var MousePosition : Vector2 = Vector2.ZERO

signal on_NewModule_drop(newmodulelist)

func _ready():
	set_process(false)
	set_physics_process(false)
	pass

func on_ButtonAdd_clicked(modulepackedscene : PackedScene, mouseposition : Vector2):
	self.MousePosition = mouseposition
	
	self.NewModule = modulepackedscene.instance()
	self.NewModule.DragEnable = false
	
	if self.NewModule.PinBoarder & 1 :
		self.MousePosition.y -= 4
	if self.NewModule.PinBoarder & 4 :
		self.MousePosition.x -= 4
	
	self.NewModule.position = self.get_viewport().get_mouse_position() - self.MousePosition
	self.add_child(self.NewModule)
	pass
	
func _input(event):
	if self.NewModule == null :
		return
	
	if event.is_action_released("mouse_left") :
		self.NewModule = null
		self.MousePosition = Vector2.ZERO
		self.emit_signal("on_NewModule_drop", self.get_children())
	
	if event is InputEventMouseMotion :
		self.NewModule.position = self.get_viewport().get_mouse_position() - self.MousePosition
		
	pass
