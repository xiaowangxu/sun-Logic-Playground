extends Module

func Update() -> void:
	$LED/SingleLED.set_LED($Pin.update_Data())
	pass

func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "LED1", "Position": [self.position.x, self.position.y], "SaveData": {}}
	