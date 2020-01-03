extends Node

class_name Line

enum PINMODE {Bus, Bit}
export(PINMODE) var LineMode : int = 0
var PinList : Array = []

var BusData : int = 0
var BitData : bool = false

func connect_Pin(pin) -> void:
	if pin.PinMode==LineMode && !PinList.has(pin):
		PinList.append(pin)
	pass

func discount_Pin(pin) -> void:
	if PinList.has(pin):
		PinList.erase(pin)
	pass

func _ready():
	pass

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
	pass

func get_Data():
	match LineMode:
		PINMODE.Bus:
			return BusData
		PINMODE.Bit:
			return BitData
	pass