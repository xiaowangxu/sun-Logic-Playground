extends Sprite

func set_Number(number : int) -> void:
	number %= 1000
	var a0 : int = number % 10
	var a1 : int = number/10 % 10
	var a2 : int = number/100 % 10
	$DigitalNumber1.frame = a0
	$DigitalNumber2.frame = a1
	$DigitalNumber3.frame = a2
	pass