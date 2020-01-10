extends Node2D

var a = 2
var ModuleList : Array = []
var ConnectionList : Array = []
var Line = preload("res://Connection/Line.tscn")


func connect_LineModule(pina, pinb, line) -> void:
	pina.connect_Line(line)
	pinb.connect_Line(line)
	line.connect_Pin(pina)
	line.connect_Pin(pinb)
	pass

func add_Module(newmodule) -> void :
	if not self.ModuleList.has(newmodule) :
		self.ModuleList.append(newmodule)
	self.refresh_ToolMode()
	pass

func add_Line(newline) -> void :
	if not self.ConnectionList.has(newline) :
		self.ConnectionList.append(newline)
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
		line.Update()
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

func refresh_ToolMode() -> void:
	if GlobalData.ToolMode == "Connect" :
		for module in self.ModuleList :
			module.drop()
			module.DragEnable = false
			for pin in module.PinList :
				pin.ClickEnable = true
	elif GlobalData.ToolMode == "Move" :
		for module in self.ModuleList :
			module.DragEnable = true
			for pin in module.PinList :
				pin.ClickEnable = false
	pass

func _on_ButtonConnect_toggled(button_pressed):
	if button_pressed :
		GlobalData.ToolMode = "Connect"
	self.refresh_ToolMode()
	pass

func _on_ButtonMove_toggled(button_pressed):
	if button_pressed :
		GlobalData.ToolMode = "Move"
	self.refresh_ToolMode()
	pass


# Connect Pins
var connectionhelper : Line2D = null
var startpin : Pin = null
var endpin : Pin = null

func _on_Pin_on_MouseLeft_click(pin : Pin):
	print("_on_Pin_on_MouseLeft_click ", pin)
	if GlobalData.ToolMode == "Connect" and startpin == null :
		startpin = pin
		if connectionhelper != null :
			self.remove_child(connectionhelper)
		connectionhelper = Line2D.new()
		self.add_child(connectionhelper)
		connectionhelper.default_color = Color8(0, 255, 0)
		connectionhelper.width = 2
		connectionhelper.begin_cap_mode = Line2D.LINE_CAP_ROUND
		connectionhelper.end_cap_mode = Line2D.LINE_CAP_ROUND
		connectionhelper.add_point(pin.to_global(self.position))
		connectionhelper.add_point(self.get_local_mouse_position())
	pass

func _unhandled_input(event : InputEvent):
	if GlobalData.ToolMode == "Connect" and connectionhelper != null and event is InputEventMouseMotion:
		connectionhelper.set_point_position(1, self.get_local_mouse_position())

func _on_Pin_on_MouseLeft_release(pin : Pin):
	if GlobalData.ToolMode == "Connect" and startpin != null and startpin != endpin:
		endpin = pin
		if startpin.PinMode == endpin.PinMode :
			var line : Line = self.Line.instance()
			line.position = (startpin.to_global(self.position) + endpin.to_global(self.position)) / 2
			line.LineMode = startpin.PinMode
			$ConnectionLine.add_child(line)
			self.add_Line(line)
			self.connect_LineModule(startpin, endpin, line)
	if connectionhelper != null :
		connectionhelper.queue_free()
		connectionhelper = null
	if startpin != null :
		 startpin = null
	if endpin != null :
		endpin = null
	pass