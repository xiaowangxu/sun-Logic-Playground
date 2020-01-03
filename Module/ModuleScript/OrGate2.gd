extends Module

func Update() -> void:
	var a = $Pin_A.update_Data()
	var b = $Pin_B.update_Data()
	$OrGate2BG/SingleLED_A.set_LED(a)
	$OrGate2BG/SingleLED_B.set_LED(b)
	$OrGate2BG/SingleLED_R.set_LED((a || b))
	$Pin_R.set_Data((a || b))
	pass