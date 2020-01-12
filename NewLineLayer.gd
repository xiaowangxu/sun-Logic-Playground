extends CanvasLayer

var Line = preload("res://Connection/Line.tscn")
export(NodePath) var ToolBoxNodePath : NodePath
onready var ToolBox = get_node(ToolBoxNodePath)
export(NodePath) var ButtonNodePath : NodePath
onready var ButtonLine = get_node(ButtonNodePath)
var NewLine : Line = null
var MousePosition : Vector2 = Vector2.ZERO

signal on_NewLine_drop(newline)

func _ready():
	set_process(false)
	set_physics_process(false)
	pass

func _on_ButtonConnect_pressed():
	if not GlobalData.ToolMode=="Move" or GlobalData.ConnectLineState :
		return

	self.MousePosition = self.get_viewport().get_mouse_position() - (ButtonLine.get_global_rect().position*2+ButtonLine.get_global_rect().size)/2.0
	
	self.NewLine = Line.instance()
	self.NewLine.DragEnable = false
	
	self.NewLine.position = self.get_viewport().get_mouse_position() - self.MousePosition
	self.add_child(self.NewLine)
	pass

	
func _input(event):
	if self.NewLine == null :
		return
	
	if event.is_action_released("mouse_left") :
		self.NewLine = null
		self.MousePosition = Vector2.ZERO
		if not ToolBox.is_Position_inside(self.get_viewport().get_mouse_position()) :
			self.emit_signal("on_NewLine_drop", self.get_children())
		else :
			for line in self.get_children() :
				self.remove_child(line)
				line.queue_free()
	
	if event is InputEventMouseMotion :
		self.NewLine.position = self.get_viewport().get_mouse_position() - self.MousePosition
	pass



