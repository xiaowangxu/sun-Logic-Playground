extends Module

var Count : int = 0

func Update() -> void:
	Count += 1
	Count %= 256
	$Pin.set_Data(Count)
	pass