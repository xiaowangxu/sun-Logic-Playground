extends Module

var Enable : bool = false
var Data : int = 0

func Update() -> void:
	Enable = $PinEnable.update_Data()
	$Sprite/SingleLED.set_LED(Enable)
	if Enable :
		var Mode : bool = $PinMode.update_Data()
		if Mode :
			Data = $PinWrite.update_Data()
			$Sprite/SingleLEDMode.set_LED(2)
		else :
			$PinRead.set_Data(Data)
			$Sprite/SingleLEDMode.set_LED(1)
	else :
		$Sprite/SingleLEDMode.set_LED(0)
	self.show_Number(Data)
	pass

func show_Number(num : int) -> void:
	var number : int = num % 1000
	var a0 : int = number % 10
	var a1 : int = number/10 % 10
	var a2 : int = number/100 % 10
	$Sprite/DigitalNumber0.frame = a0
	$Sprite/DigitalNumber1.frame = a1
	$Sprite/DigitalNumber2.frame = a2
	pass

func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Register", "Position": [self.position.x, self.position.y], "SaveData": {"Data": self.Data}}
	
func load_Module(data : Dictionary) -> void:
	if data.has("Data") :
		self.Data = data["Data"] as int
		self.show_Number(Data)
	pass
	
func reset() -> void:
	self.Data = 0