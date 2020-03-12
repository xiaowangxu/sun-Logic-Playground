extends Node

var CameraZoom : float = 1.0

var hasClickableObj : bool = false

var LineInstance = preload("res://Connection/Line.tscn")

var ModuleInstance : Dictionary = {	"Counter": preload("res://Module/Counter.tscn"), 
									"DigitalNumberScreen4": preload("res://Module/DigitalNumberScreen4.tscn"), 
									"Adder0": preload("res://Module/Adder0.tscn"),
									"AndGate2": preload("res://Module/AndGate2.tscn"),
									"OrGate2": preload("res://Module/OrGate2.tscn"),
									"NotGate": preload("res://Module/NotGate.tscn"),
									"Button1": preload("res://Module/Button1.tscn"),
									"Button8": preload("res://Module/Button8.tscn"),
									"BusEncoder8": preload("res://Module/BusEncoder8.tscn"),
									"BusEncoder10": preload("res://Module/BusEncoder10.tscn"),
									"LED1": preload("res://Module/LED1.tscn"),
									"Delay": preload("res://Module/Delay.tscn"),
									"Register": preload("res://Module/Register.tscn"),
									"Memory": preload("res://Module/Memory.tscn"),
									"ALU": preload("res://Module/ALU.tscn"),
									"1078Control": preload("res://Module/1078Control.tscn"),
									"Clock": preload("res://Module/Clock.tscn")
									}

var ToolMode : String = "Move"

var RunMode : String = "Stop"

var GridSize : float = 8.0

var ConnectLineState : bool = false
var CurrentLine = null

func XOR(a : bool, b : bool) -> bool:
	return not a == b
	
func bin2dec(a : Array) -> int:
	var mul : int = 1
	var ans : int = 0
	for idx in range(a.size()-1, -1, -1) :
		var bit : bool = a[idx]
		if bit :
			ans += mul
		mul *= 2
	return ans
	
func dec2bin(a : int, size : int = 8) -> Array:
	var ans : Array = []
	ans.resize(size)
	var idx : int = size - 1
	while a > 0 :
		ans[idx] = false if a % 2 == 0 else true
		a = (a / 2) as int
		idx -= 1
		if idx < 0 :
			break
	for i in range(idx, -1, -1) :
		ans[i] = false
	return ans
	pass
