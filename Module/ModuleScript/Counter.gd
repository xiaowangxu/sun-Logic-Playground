extends Module

var Count : int = 0

func Update() -> void:
	Count += 1
	Count %= 10000
	$Pin.set_Data(Count)
	pass
	
func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Counter", "Position": [self.position.x, self.position.y], "SaveData": {"Count": self.Count}}
	
func load_Module(data : Dictionary) -> void:
	if data.has("Count") :
		self.Count = data["Count"] as int
	pass