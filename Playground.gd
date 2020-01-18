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
	for pin in module.PinList :
		for line in pin.LineList :
			line.disconnect_Pin(pin)
	if self.ModuleList.has(module) :
		self.ModuleList.erase(module)
	pass
	
func delete_Line(line) -> void :
	for pin in line.PinList :
		pin.disconnect_Line(line)
	if self.ConnectionList.has(line) :
		self.ConnectionList.erase(line)
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
	self.refresh_ToolMode()
	pass

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		self.exit_ConnectLine()
	if GlobalData.ToolMode == "Run" and GlobalData.RunMode == "Continue" :
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
		newmodule.on_Module_drop(newmodule)
		self.add_Module(newmodule)
	pass

func _on_CanvasLayer_on_ModuleDelete_drop(module):
	$ModuleLayer.remove_child(module)
	self.delete_Module(module)
	module.queue_free()
	pass

func set_Module_Enable(clickable : bool, dragable : bool, pinclickable : bool = true) -> void:
	for module in self.ModuleList :
		if not dragable:	module.drop()
		module.DragEnable = dragable
		module.ClickEnable = clickable
		for pin in module.PinList :
			pin.ClickEnable = pinclickable

func set_Line_Enable(clickable : bool, dragable : bool) -> void:
	for line in self.ConnectionList :
		if not dragable:	line.drop()
		line.DragEnable = dragable
		line.ClickEnable = clickable

func refresh_ToolMode() -> void:
	if GlobalData.ToolMode == "Move" :
		self.set_Module_Enable(true, true, false)
		self.set_Line_Enable(true, true)
		$CanvasLayer/ToolBox/Tab/ButtonConnect.disabled = false
		$CanvasLayer/SaveLoadBox/ButtonLoad.disabled = false
		$CanvasLayer/SaveLoadBox/ButtonSave.disabled = false
		$CanvasLayer/RunBox/ButtonContiune.disabled = true
		$CanvasLayer/RunBox/ButtonStop.disabled = true
		$CanvasLayer/RunBox/ButtonNext.disabled = true
		for line in self.ConnectionList :
			line.set_Logo(0, true)
			line.set_Line(true)
	elif GlobalData.ToolMode == "Run" :
		self.set_Module_Enable(false, false, false)
		self.set_Line_Enable(false, false)
		$CanvasLayer/ToolBox/Tab/ButtonConnect.disabled = true
		$CanvasLayer/SaveLoadBox/ButtonLoad.disabled = true
		$CanvasLayer/SaveLoadBox/ButtonSave.disabled = true
		$CanvasLayer/RunBox/ButtonContiune.disabled = false
		$CanvasLayer/RunBox/ButtonStop.disabled = false
		$CanvasLayer/RunBox/ButtonNext.disabled = false
		for line in self.ConnectionList :
			line.set_Logo(0, false)
			line.set_Line(true)
	pass

func _on_ButtonMove_toggled(button_pressed):
	if button_pressed :
		GlobalData.ToolMode = "Move"
		self.refresh_ToolMode()
	pass

func _on_ButtonRun_toggled(button_pressed):
	if button_pressed :
		GlobalData.ToolMode = "Run"
		self.refresh_ToolMode()
	pass

func _on_NewLineLayer_on_NewLine_drop(newlinelist):
	for newline in newlinelist :
		newline.get_parent().remove_child(newline)
		newline.position = (newline.position - self.get_viewport_rect().size / 2) * GlobalData.CameraZoom + $Camera2D.position
		$ConnectionLine.add_child(newline)
		var parent : Node = newline.get_parent()
		parent.move_child(newline, 0)
		parent.move_child(newline, parent.get_child_count())
		newline.DragEnable = true
		newline.on_Drop(newline)
		newline.set_process(true)
		self.add_Line(newline)
	pass # Replace with function body.

func _on_CanvasLayer_on_LineDelete_drop(line):
	$ConnectionLine.remove_child(line)
	self.delete_Line(line)
	line.queue_free()
	pass # Replace with function body.

####################################
#          connect Line            #
####################################

func ready_ConnectLine(line) -> void:
	if not GlobalData.ConnectLineState :
		$CanvasLayer/ToolBox/Tab/ButtonRun.disabled = true
		$CanvasLayer/ToolBox/Tab/ButtonMove.disabled = true
		$CanvasLayer/ToolBox/Tab/ButtonConnect.disabled = true
		$CanvasLayer.hide_All()
		for line in self.ConnectionList :
			line.set_Logo(0, false)
			line.set_Line(false)
			line.set_Edit(false)
		GlobalData.CurrentLine = line
		GlobalData.ConnectLineState = true
		
		GlobalData.CurrentLine.set_Logo(1, true)
		GlobalData.CurrentLine.set_Line(true)
		
		GlobalData.CurrentLine.get_node("AnimatedSprite").frame = 1
		self.set_Module_Enable(false, false, true)
		self.set_Line_Enable(false, false)
		
func exit_ConnectLine() -> void:
	if GlobalData.ConnectLineState :
		for line in self.ConnectionList :
			line.set_Logo(0, true)
			line.set_Line(true)
			line.set_Edit(false)
		GlobalData.CurrentLine.get_node("AnimatedSprite").frame = 0
		GlobalData.ConnectLineState = false
		GlobalData.CurrentLine = null
		$CanvasLayer/ToolBox/Tab/ButtonRun.disabled = false
		$CanvasLayer/ToolBox/Tab/ButtonMove.disabled = false
		$CanvasLayer/ToolBox/Tab/ButtonConnect.disabled = false
		self.set_Module_Enable(true, true, false)
		self.set_Line_Enable(true, true)

func _input(event) -> void:
	if GlobalData.ConnectLineState and event is InputEventMouseButton and event.is_action_pressed("mouse_right") :
		self.exit_ConnectLine()

func _on_Pin_on_MouseLeft_click(pin : Pin) -> void:
	print("Pin Clicked")
	if GlobalData.ConnectLineState :
		GlobalData.CurrentLine.set_Edit(false)
		if GlobalData.CurrentLine.PinList.size() == 0 :
			GlobalData.CurrentLine.LineMode = pin.PinMode
		if !GlobalData.CurrentLine.has_Pin(pin) :
			GlobalData.CurrentLine.connect_Pin(pin, true)
			pin.connect_Line(GlobalData.CurrentLine)
		else :
			GlobalData.CurrentLine.set_Line_Edit(pin, true)
	pass

func _on_Pin_on_doubleclick(pin : Pin) -> void:
	if GlobalData.ConnectLineState :
		GlobalData.CurrentLine.set_Edit(false)
		if GlobalData.CurrentLine.has_Pin(pin) :
			GlobalData.CurrentLine.disconnect_Pin(pin)
			pin.disconnect_Line(GlobalData.CurrentLine)
	pass

####################################
#           save & load            #
####################################
func clear_Playground():
	var ModuleList : Array
	ModuleList = self.ModuleList.duplicate()
	for module in ModuleList :
		self.delete_Module(module)
		var parent = module.get_parent()
		parent.remove_child(module)
		module.queue_free()
	var LineList : Array
	LineList = self.ConnectionList.duplicate()
	for line in LineList :
		self.delete_Line(line)
		var parent = line.get_parent()
		parent.remove_child(line)
		line.queue_free()
	pass
	
func _on_ButtonClear_pressed():
	self.save_Playground()

var datastring : String = ""
var Data = null

func save_Playground() -> void:
	var ModuleSaveList : Array = []
	var idx : int = 0
	for module in self.ModuleList :
		module.SaveID = idx
		idx += 1
		ModuleSaveList.append(module.save_Module())
	
	var LineSaveList : Array = []
	for line in self.ConnectionList :
		LineSaveList.append(line.save_Line())
	
	self.Data = {"CameraPosition": [$Camera2D.position.x, $Camera2D.position.y], "ModuleCount": self.ModuleList.size(), "ModuleList": ModuleSaveList, "LineList": LineSaveList}
	self.datastring = to_json(self.Data)

func load_Playground(path : String) -> void:
	var fileloader : File = File.new()
	if fileloader.file_exists(path) :
		fileloader.open(path, File.READ)
		self.datastring = fileloader.get_line()
		self.Data = parse_json(self.datastring)
		
		$Camera2D.position = Vector2(Data["CameraPosition"][0], Data["CameraPosition"][1])
		
		var ModuleList : Array = []
		ModuleList.resize(Data["ModuleCount"])
		
		for moduledata in Data["ModuleList"] :
#			print(str(moduledata))
			if GlobalData.ModuleInstance.has(moduledata["Module"]) :
				var module : Module = GlobalData.ModuleInstance[moduledata["Module"]].instance()
				module.Init()
				module.load_Module(moduledata["SaveData"])
				ModuleList[moduledata["SaveID"]] = module
				$ModuleLayer.add_child(module)
				module.position = Vector2(moduledata["Position"][0], moduledata["Position"][1])
				var parent : Node = module.get_parent()
				parent.move_child(module, 0)
				parent.move_child(module, parent.get_child_count())
				module.DragEnable = true
				module.on_Module_drop(module)
				self.add_Module(module)
#				print(ModuleList)
		
		for linedata in Data["LineList"] :
#			print(linedata)
			var line : Line = GlobalData.LineInstance.instance()
			$ConnectionLine.add_child(line)
			line.position = Vector2(linedata["Position"][0], linedata["Position"][1])
			line.LineMode = linedata["LineMode"] as int
			var parent : Node = line.get_parent()
			parent.move_child(line, 0)
			parent.move_child(line, parent.get_child_count())
			line.DragEnable = true
			line.on_Drop(line)
			line.set_process(true)
			self.add_Line(line)
			for pindata in linedata["PinList"] :
				var pin : Pin = ModuleList[pindata["ModuleSaveID"]].get_node(pindata["PinName"])
				line.connect_Pin(pin, false, pindata["LinePoints"])
				pin.connect_Line(line)
		
		fileloader.close()
	pass

func _on_ButtonSave_pressed():
	$CanvasLayer/FileDialogSave.popup_centered()
	pass # Replace with function body.

func _on_FileDialogSave_file_selected(path):
	self.save_Playground()
	var filesaver : File = File.new()
	filesaver.open(path, File.WRITE)
	filesaver.store_line(self.datastring)
	filesaver.close()
	pass # Replace with function body.


func _on_ButtonLoad_pressed():
	$CanvasLayer/FileDialogLoad.popup_centered()
	pass # Replace with function body.


func _on_FileDialogLoad_file_selected(path):
	self.clear_Playground()
	self.load_Playground(path)
	$CanvasLayer.hide_All()
	pass # Replace with function body.

####################################
#           run  control           #
####################################
func _on_ButtonContiune_toggled(button_pressed):
	if button_pressed :
		$CanvasLayer/RunBox/ButtonNext.disabled = true
		GlobalData.RunMode = "Continue"
	pass # Replace with function body.


func _on_ButtonStop_toggled(button_pressed):
	if button_pressed :
		$CanvasLayer/RunBox/ButtonNext.disabled = false
		GlobalData.RunMode = "Stop"
	pass # Replace with function body.

func _on_ButtonNext_pressed():
	self.update_Playground()
	pass # Replace with function body.

func _on_ButtonReset_pressed():
	for module in self.ModuleList :
		module.reset_Module()
	for line in self.ConnectionList :
		line.reset_Line()
	pass # Replace with function body.
