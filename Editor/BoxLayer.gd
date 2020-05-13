extends CanvasLayer

export(Array, NodePath) var BoxArray : Array
export(NodePath) var DeleteBoxNodePath : NodePath
onready var DeleteBox = get_node(DeleteBoxNodePath)

signal on_ModuleDelete_drop(module)
signal on_LineDelete_drop(line)

func hide_All() -> void :
	for boxnodepath in BoxArray :
		var box = get_node(boxnodepath)
		if not box.Pinned :
			box.hide()
	pass

func show_DeleteBox() -> void:
	self.DeleteBox.show()
	pass
	
func hide_DeleteBox() -> void:
	self.DeleteBox.hide()
	pass
	
func highlight_DeleteBox(highlight : bool) -> void:
	self.DeleteBox.get_node("Logo").self_modulate.a = 0.85 if highlight else 0.25
	pass
	
func on_Module_drag(module : Module) -> void:
	self.hide_All()
	self.show_DeleteBox()
	pass
	
func on_Module_drop(module : Module) -> void:
	self.hide_DeleteBox()
	if self.DeleteBox.is_Position_inside(self.get_viewport().get_mouse_position()) :
		self.emit_signal("on_ModuleDelete_drop", module)
	pass
	
func on_Line_drag(line : Line) -> void:
	self.hide_All()
	self.show_DeleteBox()
	pass
	
func on_Line_drop(line : Line) -> void:
	self.hide_DeleteBox()
	if self.DeleteBox.is_Position_inside(self.get_viewport().get_mouse_position()) :
		self.emit_signal("on_LineDelete_drop", line)
	else :
		line.on_Drop(line)
	pass
	
func is_Module_dragging(module : Module) -> void:
	self.highlight_DeleteBox(self.DeleteBox.is_Position_inside(self.get_viewport().get_mouse_position()))
	pass
