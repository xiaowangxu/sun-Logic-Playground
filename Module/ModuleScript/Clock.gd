extends Module

var Count : int = 0
var Speed : int = 8

func Update() -> void:
	if Count % Speed == 0 :
		$Pin.set_Data(true)
	else :
		$Pin.set_Data(false)
	Count += 1
	Count %= Speed
	pass

func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Clock", "Position": [self.position.x, self.position.y], "SaveData": {"Count": self.Count}}

func load_Module(data : Dictionary) -> void:
	if data.has("Count") :
		self.Count = data["Count"] as int
	pass

func reset() -> void:
	self.Count = 0
