extends Node2D

var a = 2
export(Array, NodePath) var ModuleList : Array
export(Array, NodePath) var ConnectionList : Array

func connect_LineModule(pina, pinb, line) -> void:
	pina.connect_Line(line)
	pinb.connect_Line(line)
	line.connect_Pin(pina)
	line.connect_Pin(pinb)
	pass

func _ready():
	$Counter/Pin.connect_Line($ConnectionLine/Line)
	$DigitalNumberScreen4/Pin_Number.connect_Line($ConnectionLine/Line)
	$ConnectionLine/Line.connect_Pin($Counter/Pin)
	$ConnectionLine/Line.connect_Pin($DigitalNumberScreen4/Pin_Number)
	
	self.connect_LineModule($AndGate2/Pin_A, $Button1/Pin, $ConnectionLine/Line2)
	self.connect_LineModule($AndGate3/Pin_B, $Button2/Pin, $ConnectionLine/Line3)
	self.connect_LineModule($AndGate2/Pin_R, $AndGate3/Pin_A, $ConnectionLine/Line4)
	self.connect_LineModule($AndGate3/Pin_R, $AndGate2/Pin_B, $ConnectionLine/Line5)
	pass

func _process(delta : float) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
	update_Playground()
	pass

func update_Playground() -> void:
	for module in ModuleList:
		get_node(module).Update()
	for line in ConnectionList:
		get_node(line).Update()
	pass
