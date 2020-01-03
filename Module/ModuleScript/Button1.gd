extends Module

func Update() -> void:
	$Pin.set_Data($ButtonBG/SingleButton.get_State())
	pass

func _on_SingleButton_button_Clicked(state):
	$ButtonBG/SingleLED.set_LED(state)
	pass
