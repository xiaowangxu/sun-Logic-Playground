extends Node2D

class_name Pin

enum PINMODE {Bus, Bit}
export(PINMODE) var PinMode : int = 0
var LineList : Array = []
var BusData : int = 0
var BitData : bool = false
var ClickEnable : bool = true
var Clicked : bool = false

signal on_MouseLeft_click(pin)
signal on_Click_release(pin)
signal on_MouseLeft_release(pin)
signal on_doubleclick(pin)

func connect_Line(line) -> void:
	if line.LineMode==PinMode && !LineList.has(line):
		LineList.append(line)
	pass

func disconnect_Line(line) -> void:
	if LineList.has(line):
		LineList.erase(line)
	pass

func _ready():
	set_process(false)
	set_physics_process(false)
	#self.connect("on_Click_release", get_node("/root/Playground"), "_on_Pin_on_MouseLeft_release")
	self.connect("on_MouseLeft_click", get_node("/root/Playground"), "_on_Pin_on_MouseLeft_click")
	self.connect("on_doubleclick", get_node("/root/Playground"), "_on_Pin_on_doubleclick")
#	self.connect("on_MouseLeft_release", get_node("/root/Playground"), "_on_Pin_on_MouseLeft_release")
	match PinMode:
		PINMODE.Bus:
			$AnimatedSprite.frame = 0
			var shape : RectangleShape2D = RectangleShape2D.new()
			shape.extents = Vector2(16, 2)
			$Area2D/CollisionShape2D.shape = shape
		PINMODE.Bit:
			$AnimatedSprite.frame = 1
			var shape : RectangleShape2D = RectangleShape2D.new()
			shape.extents = Vector2(2, 2)
			$Area2D/CollisionShape2D.shape = shape
	pass # Replace with function body.

func set_Data(data) -> void:
	match PinMode:
		PINMODE.Bus:
			BusData = data
		PINMODE.Bit:
			BitData = data
	pass

func update_Data():
	match PinMode:
		PINMODE.Bus:
			var ans : int = 0
			for line in LineList:
				var lineobj = line
				ans = ans | lineobj.get_Data()
			return ans
			#print(BusData)
		PINMODE.Bit:
			var ans : bool = false
			for line in LineList:
				var lineobj = line
				ans = ans || lineobj.get_Data()
			return ans
	pass

func get_Data():
	match PinMode:
		PINMODE.Bus:
			return BusData
		PINMODE.Bit:
			return BitData
	pass

func _on_Area2D_input_event(viewport : Node, event : InputEvent, shape_idx : int) -> void:
	if self.ClickEnable and event is InputEventMouseButton and event.doubleclick and event.button_index == BUTTON_LEFT:
		self.emit_signal("on_doubleclick", self)
		return
	if self.ClickEnable :
		if not GlobalData.hasClickableObj and event.is_action_pressed("mouse_left") :
			GlobalData.hasClickableObj = true
			#print(str(self)," clicked")
			self.emit_signal("on_MouseLeft_click", self)
			self.Clicked = true
		if event.is_action_released("mouse_left") :
			#print("Buttom Release: " + str(self))
			self.emit_signal("on_MouseLeft_release", self)
	pass
	
func _unhandled_input(event : InputEvent):
	if self.Clicked and event.is_action_released("mouse_left") :
		GlobalData.hasClickableObj = false
		self.Clicked = false
		#print("Button Click Released "+ str(self))
		if self.ClickEnable :
			self.emit_signal("on_Click_release", self)
	pass
