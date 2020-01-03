extends Module

func XOR(a : bool, b : bool) -> bool:
	return not a == b

func Update() -> void:
	var a = $Pin_A.update_Data()
	var b = $Pin_B.update_Data()
	var c = $Pin_C.update_Data()
	$Adder0BG/SingleLED_A.set_LED(a)
	$Adder0BG/SingleLED_B.set_LED(b)
	$Adder0BG/SingleLED_C.set_LED(c)
	#print(str(a)+" "+str(b)+" "+str(c))
	var c1 = a&&b || c && (a||b)
	var r = XOR(XOR(a, b), c)
	$Adder0BG/SingleLED_C1.set_LED(c1)
	$Adder0BG/SingleLED_R.set_LED(r)
	$Pin_C1.set_Data(c1)
	$Pin_R.set_Data(r)
	pass
