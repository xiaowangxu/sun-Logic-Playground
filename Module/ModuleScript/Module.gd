extends Node2D

class_name Module

onready var DragArea = get_node("Area2D")

const GridSize : float = 8.0
var LastPosition : Vector2 = Vector2.ZERO
var IsDragging : bool = false
export(Vector2) var ShiftPosition : Vector2 = Vector2.ZERO

func _ready():
	set_process(false)
	set_physics_process(false)
#	print(str(CollisionBox))
	if DragArea != null && DragArea is Area2D :
		print(str(DragArea))
		DragArea.connect("input_event", self, "DragArea_InputEvent")
		print(DragArea.get_signal_connection_list("input_event"))
	pass

func Update() -> void:
	pass


func DragArea_InputEvent(viewport : Node, event : InputEvent, shape : int) -> void:
	if event.is_action_pressed("mouse_left") :
		print(event)
		get_tree().set_input_as_handled()
		self.LastPosition = event.position
		self.IsDragging = true
		var parent : Node = self.get_parent()
		parent.move_child(self, parent.get_child_count())
	pass
	
func _input(event):
	if not self.IsDragging :
		return
	if event.is_action_released("mouse_left") : 
		self.LastPosition = Vector2.ZERO
		self.IsDragging = false
		var new_position : Vector2 = self.position
		self.position.x = round((self.position.x - (self.GridSize + self.ShiftPosition.x) / 2.0) / self.GridSize) * self.GridSize + self.ShiftPosition.x
		self.position.y = round((self.position.y - (self.GridSize + self.ShiftPosition.y) / 2.0) / self.GridSize) * self.GridSize + self.ShiftPosition.y
		
	if self.IsDragging and event is InputEventMouseMotion:
		self.position += (event.position - LastPosition)
		self.LastPosition = event.position
		
	pass
