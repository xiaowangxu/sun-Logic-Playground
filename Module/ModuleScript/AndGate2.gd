extends Module

func Update() -> void:
	var a = $Pin_A.update_Data()
	var b = $Pin_B.update_Data()
	$AndGate2BG/SingleLED_A.set_LED(a)
	$AndGate2BG/SingleLED_B.set_LED(b)
	$AndGate2BG/SingleLED_R.set_LED((a && b))
	$Pin_R.set_Data((a && b))
	pass
	
func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "AndGate2", "Position": [self.position.x, self.position.y], "SaveData": {}}
