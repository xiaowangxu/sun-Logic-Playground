extends Module

func Update() -> void:
	$PinOut.set_Data($PinIn.update_Data())
	pass

func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Delay", "Position": [self.position.x, self.position.y], "SaveData": {}}
	
