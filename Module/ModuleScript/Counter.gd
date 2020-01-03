extends Module

var Count : int = 0

func Update() -> void:
	Count += 1
	Count %= 10000
	$Pin.set_Data(Count)
	pass
