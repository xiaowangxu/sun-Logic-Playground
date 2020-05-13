extends Module

func Update() -> void:
	var a = $Pin_A.update_Data()
	$NotGateBG/SingleLED_A.set_LED(a)
	$NotGateBG/SingleLED_R.set_LED(!a)
	$Pin_R.set_Data(!a)
	pass
	
func save_Module() -> Dictionary :
	return {"SaveID": self.SaveID, "Module": "NotGate", "Position": [self.position.x, self.position.y], "SaveData": {}}
