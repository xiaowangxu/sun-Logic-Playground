tool
extends Node2D

class_name Pin

enum PINMODE {Bus, Bit}
export(PINMODE) var PinMode : int = 0 setget set_PinMode
var LineList : Array = []
var BusData : int = 0
var BitData : bool = false

func connect_Line(line) -> void:
	if line.LineMode==PinMode && !LineList.has(line):
		LineList.append(line)
	pass

func discount_Line(line) -> void:
	if LineList.has(line):
		LineList.erase(line)
	pass

func set_PinMode(pinmode : int) -> void:
	PinMode = pinmode
	match PinMode:
		PINMODE.Bus:
			$AnimatedSprite.frame = 0
		PINMODE.Bit:
			$AnimatedSprite.frame = 1
	pass

func _ready():
	set_process(false)
	set_physics_process(false)
	pass # Replace with function body.

func set_Data(data) -> void:
	match PinMode:
		PINMODE.Bus:
			BusData = data
			$Label.text = str(BusData)
		PINMODE.Bit:
			BitData = data
			$Label.text = str(BitData)
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