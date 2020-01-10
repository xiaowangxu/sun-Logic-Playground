extends Node2D

class_name Line

enum PINMODE {Bus, Bit}
export(PINMODE) var LineMode : int = 0
var PinList : Array = []

var BusData : int = 0
var BitData : bool = false

func connect_Pin(pin) -> void:
	if pin.PinMode==LineMode && !PinList.has(pin):
		PinList.append(pin)
		
	self.refresh_Visaul()
	pass

func discount_Pin(pin) -> void:
	if PinList.has(pin):
		PinList.erase(pin)
		
	self.refresh_Visaul()
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
				line.default_color = lerp(Color8(26, 200, 68, 255), Color8(255, 120, 60, 255), clamp(self.BusData, 0, 255) / 255.0)
		PINMODE.Bit:
			for line in $LineHelper.get_children() :
				line.default_color = Color8(255, 120, 60, 255) if self.BitData else Color8(73, 173, 233, 255)

func refresh_Visaul() -> void :
	for line in $LineHelper.get_children() :
		line.queue_free()
	for pin in self.PinList :
		var connectionhelper : Line2D = Line2D.new()
		if self.LineMode == PINMODE.Bus :
			connectionhelper.texture = preload("res://Connection/Texture-bus.png")
			connectionhelper.texture_mode = Line2D.LINE_TEXTURE_STRETCH
		$LineHelper.add_child(connectionhelper)
		connectionhelper.default_color = Color8(73, 173, 233, 255)
		connectionhelper.width = 4 if self.LineMode==1 else 25
		connectionhelper.begin_cap_mode = Line2D.LINE_CAP_ROUND
		connectionhelper.end_cap_mode = Line2D.LINE_CAP_ROUND
		connectionhelper.add_point(Vector2.ZERO)
		connectionhelper.add_point(self.to_local(pin.to_global(self.get_node("/root/Playground").position)))
		
func move_Visual() -> void:
	var center : Vector2 = Vector2.ZERO
	for pin in self.PinList :
		center += pin.to_global(self.get_node("/root/Playground").position)
	center /= self.PinList.size()
	self.position = center
	var children : Array = $LineHelper.get_children()
	var minnum : int = min(children.size(), self.PinList.size())
	for i in range(minnum) :
		var line : Line2D = children[i]
		var pin : Pin = self.PinList[i]
		line.set_point_position(1, self.to_local(pin.to_global(self.get_node("/root/Playground").position)))
	pass