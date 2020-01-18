extends Module

func Update() -> void:
	$Pin.set_Data($ButtonBG/SingleButton.get_State())
	pass

func _on_SingleButton_button_Clicked(state : bool, idx : int):
	$ButtonBG/SingleLED.set_LED(state)
	pass

func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Button1", "Position": [self.position.x, self.position.y], "SaveData": {"ButtonState": $ButtonBG/SingleButton.get_State()}}
	
func load_Module(data : Dictionary) -> void:
	if data.has("ButtonState") :
		$ButtonBG/SingleButton.set_Button(data["ButtonState"] as bool)
		$ButtonBG/SingleLED.set_LED(data["ButtonState"] as bool)
	pass