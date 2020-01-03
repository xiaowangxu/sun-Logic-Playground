extends Module

func Update() -> void:
	$LED/SingleLED.set_LED($Pin.update_Data())
	pass
