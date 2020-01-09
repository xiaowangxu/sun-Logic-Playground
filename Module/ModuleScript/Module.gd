extends Node2D

class_name Module

onready var DragArea = get_node("Area2D")

const GridSize : float = 8.0
var LastPosition : Vector2 = Vector2.ZERO
var LastDragState : bool = false
var IsDragging : bool = false
export(bool) var DragEnable : bool = true
export(Vector2) var ShiftPosition : Vector2 = Vector2.ZERO
export(int, FLAGS, "Up", "Down", "Left", "Right") var PinBoarder : int = 0

signal on_drag
signal is_dragging
signal on_drop

func _ready():
	set_process(false)
	set_physics_process(false)
	self.connect("on_drag", get_node("/root/Playground/CanvasLayer"), "hide_All")
#	print(str(CollisionBox))
	if DragArea != null && DragArea is Area2D :
		#print(str(DragArea))
		DragArea.connect("input_event", self, "DragArea_InputEvent")
		#print(DragArea.get_signal_connection_list("input_event"))
	pass

func Update() -> void:
	pass

func drop() -> void:
	self.remove_from_group("dragging_module")
	self.LastPosition = Vector2.ZERO
	self.IsDragging = false
	self.LastDragState = false
	pass

func get_Rect2() -> Rect2 :
	var rect : Rect2 = Rect2(0,  0, 0, 0)
	var size : Vector2 = self.get_node("Area2D/CollisionShape2D").shape.extents * 2
	
	if self.PinBoarder & 1 :
		rect.position.y -= 4
		size.y += 4
	if self.PinBoarder & 4 :
		rect.position.x -= 4
		size.x += 4
	if self.PinBoarder & 2 :
		size.y += 4
	if self.PinBoarder & 8 :
		size.x += 4
		
	rect.size = size
	
	return rect

func DragArea_InputEvent(viewport : Node, event : InputEvent, shape : int) -> void:
	if self.DragEnable and event.is_action_pressed("mouse_left") :
		if get_tree().get_nodes_in_group("dragging_module").size() == 0 :
			self.add_to_group("dragging_module")
			self.LastPosition = event.position
			self.IsDragging = true
		else :
			var module = get_tree().get_nodes_in_group("dragging_module")[0]
			if module.get_index() <= self.get_index() :
				module.IsDragging = false
				module.remove_from_group("dragging_module")
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
			self.emit_signal("on_drag")
			if self.IsDragging :
				var parent : Node = self.get_parent()
				parent.move_child(self, parent.get_child_count())
		
	if self.IsDragging and event.is_action_released("mouse_left") : 
		self.remove_from_group("dragging_module")
		self.LastPosition = Vector2.ZERO
		self.IsDragging = false
		if self.LastDragState :
			self.emit_signal("on_drop")
		self.LastDragState = false
		#var new_position : Vector2 = self.position
		#self.position.x = round((self.position.x - (self.GridSize + self.ShiftPosition.x) / 2.0) / self.GridSize) * self.GridSize + self.ShiftPosition.x
		#self.position.y = round((self.position.y - (self.GridSize + self.ShiftPosition.y) / 2.0) / self.GridSize) * self.GridSize + self.ShiftPosition.y
		
	if self.IsDragging and event is InputEventMouseMotion:
		self.position += (event.position - LastPosition) * GlobalData.CameraZoom
		self.LastPosition = event.position
		self.emit_signal("is_dragging")
		
	pass
