extends Node2D

class_name Line

enum PINMODE {Bus, Bit}
export(PINMODE) var LineMode : int = 0
var PinList : Array = []

var BusData : int = 0
var BitData : bool = false

var LastPosition : Vector2 = Vector2.ZERO
var LastDragState : bool = false
var IsDragging : bool = false
export(bool) var DragEnable : bool = true
export(bool) var ClickEnable : bool = true

var LineHelper = preload("res://Connection/LineHelper.tscn")

signal on_drag(line)
signal is_dragging(line)
signal on_drop(line)
signal on_doubleclick(line)

func connect_Pin(pin : Pin, edit : bool = false, points : Array = []) -> void:
	if pin.PinMode==LineMode && !PinList.has(pin):
		PinList.append(pin)
		var linehelper = LineHelper.instance()
		linehelper.target = pin
		$LineHelper.add_child(linehelper)
		linehelper.default_color = Color8(73, 173, 233, 255)
		linehelper.width = 4 if self.LineMode==1 else 25
		linehelper.begin_cap_mode = Line2D.LINE_CAP_ROUND
		linehelper.end_cap_mode = Line2D.LINE_CAP_ROUND
		linehelper.joint_mode = Line2D.LINE_JOINT_ROUND
		linehelper.add_point(Vector2.ZERO)
		if !points.empty() :
			for pointdata in points :
				linehelper.add_point(Vector2(pointdata[0], pointdata[1]))
		linehelper.add_point(self.to_local(linehelper.target.to_global(self.get_node("/root/Playground").position)))
		if edit :
			linehelper.start_Edit()
	pass

func disconnect_Pin(pin) -> void:
	if PinList.has(pin):
		PinList.erase(pin)
		for linehelper in $LineHelper.get_children() :
			if not PinList.has(linehelper.target) :
#				print("remove ", str(linehelper))
				$LineHelper.remove_child(linehelper)
				linehelper.queue_free()
	pass

func has_Pin(pin) -> bool:
	return PinList.has(pin)
	pass

func _ready():
	set_process(false)
	set_physics_process(false)
	self.connect("is_dragging", self, "is_Dragging")
	
	self.connect("on_drag", get_node("/root/Playground/CanvasLayer"), "on_Line_drag")
	self.connect("on_drop", get_node("/root/Playground/CanvasLayer"), "on_Line_drop")
	self.connect("is_dragging", get_node("/root/Playground/CanvasLayer"), "is_Module_dragging")
	self.connect("on_doubleclick", get_node("/root/Playground"), "ready_ConnectLine")
	
	pass

func _process(delta):
	$AnimatedSprite.scale = Vector2(GlobalData.CameraZoom, GlobalData.CameraZoom)

func Update() -> void:
	match LineMode:
		PINMODE.Bus:
			BusData = 0
			for pin in PinList:
				BusData = BusData | pin.get_Data()
		PINMODE.Bit:
			BitData = false
			for pin in PinList:
				BitData = BitData || pin.get_Data()
	self.update_Visual()
	pass

func get_Data():
	match LineMode:
		PINMODE.Bus:
			return BusData
		PINMODE.Bit:
			return BitData
	pass
	
func update_Visual() -> void:
	match LineMode:
		PINMODE.Bus:
			for line in $LineHelper.get_children() :
				line.default_color = lerp(Color8(73, 173, 233, 255), Color8(255, 120, 60, 255), clamp(self.BusData, 0, 255) / 255.0)
		PINMODE.Bit:
			for line in $LineHelper.get_children() :
				line.default_color = Color8(255, 120, 60, 255) if self.BitData else Color8(110, 140, 160, 255)

func reset_Visual() -> void:
	match LineMode:
		PINMODE.Bus:
			for line in $LineHelper.get_children() :
				line.default_color = Color8(73, 173, 233, 255)
		PINMODE.Bit:
			for line in $LineHelper.get_children() :
				line.default_color = Color8(73, 173, 233, 255)

func move_Visual() -> void:
#	var center : Vector2 = Vector2.ZERO
#	for pin in self.PinList :
#		center += pin.to_global(self.get_node("/root/Playground").position)
#	center /= self.PinList.size()
#	self.position = center
	#print(">> move")
	for line in $LineHelper.get_children() :
		line.set_point_position(line.get_point_count()-1, self.to_local(line.target.to_global(self.get_node("/root/Playground").position)))
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
			var module = get_tree().get_nodes_in_group("dragging_module")[0]
			if module.is_in_group("Module") or module.get_index() <= self.get_index() :
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
	
func is_Dragging(line) -> void:
	self.move_Visual()
	pass
	
func on_Drop(line) -> void:
	self.position.x = round(self.position.x / GlobalData.GridSize) * GlobalData.GridSize
	self.position.y = round(self.position.y / GlobalData.GridSize) * GlobalData.GridSize
	self.move_Visual()
	pass
	
func set_Logo(frame : int, show : bool) -> void:
	$AnimatedSprite.frame = frame
	$AnimatedSprite.visible = show
	pass
	
func set_Line(show : bool) -> void:
	for line in $LineHelper.get_children() :
		if show :
			line.default_color.a = 1.0
		else :
			line.default_color.a = 0.1
	pass
	
func set_Edit(edit : bool) -> void:
	if edit :
		for line in $LineHelper.get_children() :
			line.start_Edit()
	else :
		for line in $LineHelper.get_children() :
			line.exit_Edit()

func set_Line_Edit(pin : Pin, edit : bool) -> void:
	self.set_Edit(false)
	if self.has_Pin(pin) :
		for line in $LineHelper.get_children() :
			if line.target == pin :
				line.start_Edit()
				return
	pass
	
func save_Line() -> Dictionary:
	var PinList : Array = []
	for pin in self.PinList :
		var linehelper : Line2D = null
		for line in $LineHelper.get_children() :
			if line.target == pin :
				linehelper = line
		var points : Array = []
		if linehelper.points.size() > 2 :
			for idx in range(1, linehelper.points.size()-1) :
				var point : Vector2 = linehelper.points[idx]
				points.append([point.x, point.y])
		var ModuleSaveID : int = pin.get_parent().SaveID
		PinList.append({"ModuleSaveID": ModuleSaveID, "PinName": pin.name, "LinePoints": points})
	var data : Dictionary = {"LineMode": self.LineMode, "Position": [self.position.x, self.position.y], "PinList": PinList}
	return data
	
func reset_Line() -> void:
	self.BusData = 0
	self.BitData = false
	self.update_Visual()
	pass
