extends Module

var Count : int = 0
var AddLastState : bool = false

func Update() -> void:
	var enable : bool = $PinEnable.update_Data()
	$CounterBG/SingleLED.set_LED(enable)
	if enable :
		if $PinAdd.update_Data() :
			if not AddLastState :
				Count += 1
				Count %= 256
				AddLastState = true
		else :
			AddLastState = false
			if $PinSet.update_Data() :
				Count = clamp($PinWrite.update_Data(), 0, 255)
		if $PinMode.update_Data() :
			$PinRead.set_Data(self.Count)
		else :
			$PinRead.set_Data(0)
	else :
		AddLastState = false
		$PinRead.set_Data(0)
	$CounterBG/DigitalScreen3.set_Number(self.Count)
	pass
	
func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Counter", "Position": [self.position.x, self.position.y], "SaveData": {"Count": self.Count}}
	
func load_Module(data : Dictionary) -> void:
	if data.has("Count") :
		self.Count = data["Count"] as int
	pass
	
func reset() -> void:
	self.Count = 0