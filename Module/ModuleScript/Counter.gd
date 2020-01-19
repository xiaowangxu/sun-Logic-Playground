extends Module

var Count : int = 0
var AddLastState : bool = false
var ResetLastState : bool = false

func Update() -> void:
	if $PinAdd.update_Data() :
		if not AddLastState :
			Count += 1
			Count %= 256
			AddLastState = true
	else :
		AddLastState = false
	if $PinReset.update_Data() :
		if not ResetLastState :
			Count = 0
			ResetLastState = true
	else :
		ResetLastState = false
	$Pin.set_Data(Count)
	pass
	
func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Counter", "Position": [self.position.x, self.position.y], "SaveData": {"Count": self.Count}}
	
func load_Module(data : Dictionary) -> void:
	if data.has("Count") :
		self.Count = data["Count"] as int
	pass
	
func reset() -> void:
	self.Count = 0