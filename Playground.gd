extends Node2D

var a = 2
var ModuleList : Array = []
export(Array, NodePath) var ConnectionList : Array

func connect_LineModule(pina, pinb, line) -> void:
	pina.connect_Line(line)
	pinb.connect_Line(line)
	line.connect_Pin(pina)
	line.connect_Pin(pinb)
	pass

func add_Module(newmodule) -> void :
	if not self.ModuleList.has(newmodule) :
		self.ModuleList.append(newmodule)
	pass
	
func delete_Module(module) -> void :
	if self.ModuleList.has(module) :
		self.ModuleList.erase(module)
	pass

func arrange_Module() -> void :
	var maxwidth : float = $Camera2D.position.x + self.get_viewport_rect().size.x / 2 - 100
	var startx : float = ($Camera2D.position - self.get_viewport_rect().size / 2).x
	var currentposition : Vector2 = $Camera2D.position - self.get_viewport_rect().size / 2
	currentposition += Vector2(70, 20)
	var thislinemaxheight : float = 0
	
	for module in self.ModuleList :
		var modulesize : Vector2 = module.get_Rect2().size - module.get_Rect2().position
		if currentposition.x + modulesize.x > maxwidth : 
			currentposition.y += thislinemaxheight + 8
			currentposition.x = startx
		module.position = currentposition
		currentposition.x += modulesize.x + 8
		thislinemaxheight = max(thislinemaxheight, modulesize.y)

func _ready():
	pass

func _process(delta : float) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
	update_Playground()
	pass

func update_Playground() -> void:
	for module in ModuleList:
		module.Update()
	for line in ConnectionList:
		get_node(line).Update()
	pass

func _on_NewModuleLayer_on_NewModule_drop(newmodulelist):
	#print(newmodulelist)
	for newmodule in newmodulelist :
		newmodule.get_parent().remove_child(newmodule)
		newmodule.position = (newmodule.position - self.get_viewport_rect().size / 2) * GlobalData.CameraZoom + $Camera2D.position + newmodule.get_node("Area2D/CollisionShape2D").shape.extents * (GlobalData.CameraZoom - 1)
		$ModuleLayer.add_child(newmodule)
		var parent : Node = newmodule.get_parent()
		parent.move_child(newmodule, 0)
		parent.move_child(newmodule, parent.get_child_count())
		newmodule.DragEnable = true
		self.add_Module(newmodule)
	pass

func _on_CanvasLayer_on_ModuleDelete_drop(module):
	self.delete_Module(module)
	module.queue_free()
	pass
