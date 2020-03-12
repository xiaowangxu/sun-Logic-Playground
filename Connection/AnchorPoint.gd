extends AnimatedSprite

var Index : int = 0

var LastPosition : Vector2 = Vector2.ZERO
var LastDragState : bool = false
var IsDragging : bool = false
export(bool) var DragEnable : bool = true
export(bool) var ClickEnable : bool = true

signal on_drag(point)
signal is_dragging(point)
signal on_drop(point)
signal on_doubleclick(point)

func _ready():
	set_physics_process(false)

func _process(delta):
	self.scale = Vector2(GlobalData.CameraZoom, GlobalData.CameraZoom)
	pass

func drop() -> void:
	if self.is_in_group("dragging_module") :
		self.remove_from_group("dragging_module")
	self.LastPosition = Vector2.ZERO
	self.IsDragging = false
	self.LastDragState = false
	pass
	
func DragArea_InputEvent(viewport : Node, event : InputEvent, shape : int) -> void:
	if self.ClickEnable and event is InputEventMouseButton and event.doubleclick and event.button_index == BUTTON_LEFT:
		#print('double click ', event)
		self.emit_signal("on_doubleclick", self)
		return

	if self.DragEnable and event.is_action_pressed("mouse_left") :
		if get_tree().get_nodes_in_group("dragging_module").size() == 0 :
			self.add_to_group("dragging_module")
			self.LastPosition = event.position
			self.IsDragging = true
		else :
			self.IsDragging = false
	pass
	
func _unhandled_input(event):
	if not self.IsDragging :
		return
	
	if not self.DragEnable :
		self.remove_from_group("dragging_module")
		self.LastPosition = Vector2.ZERO
		self.IsDragging = false
		self.LastDragState = false
	
	#self.get_tree().set_input_as_handled()
	
	if event is InputEventMouseMotion:
		if not self.LastDragState :
			self.LastDragState = true
			self.emit_signal("on_drag", self)
			if self.IsDragging :
				var parent : Node = self.get_parent()
				parent.move_child(self, parent.get_child_count())
		
	if self.IsDragging and event.is_action_released("mouse_left") : 
		self.remove_from_group("dragging_module")
		self.LastPosition = Vector2.ZERO
		self.IsDragging = false
		if self.LastDragState :
			self.emit_signal("on_drop", self)
		self.LastDragState = false
		#var new_position : Vector2 = self.position
		#self.position.x = round((self.position.x - (self.GridSize + self.ShiftPosition.x) / 2.0) / self.GridSize) * self.GridSize + self.ShiftPosition.x
		#self.position.y = round((self.position.y - (self.GridSize + self.ShiftPosition.y) / 2.0) / self.GridSize) * self.GridSize + self.ShiftPosition.y
		
	if self.IsDragging and event is InputEventMouseMotion:
		self.position += (event.position - LastPosition) * GlobalData.CameraZoom
		self.LastPosition = event.position
		self.emit_signal("is_dragging", self)
		
	pass
	
