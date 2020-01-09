extends Module
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Number0 = $DigitalNumberScreen4/DigitalNumber0
onready var Number1 = $DigitalNumberScreen4/DigitalNumber1
onready var Number2 = $DigitalNumberScreen4/DigitalNumber2
onready var Number3 = $DigitalNumberScreen4/DigitalNumber3

var number : int = 0
var show_type : bool = false

func Update() -> void:
	number = $Pin_Number.update_Data()
	self.show()
	$Pin_Number.set_Data(0)
	pass

func show() -> void:
	number %= 10000
	var a0 : int = number % 10
	var a1 : int = number/10 % 10
	var a2 : int = number/100 % 10
	var a3 : int = number/1000 % 10
	Number0.frame = a0
	Number1.frame = a1
	Number2.frame = a2
	Number3.frame = a3
	pass


func _on_DigitalNumberScreen4_on_drag():
	print("on_drag")
	pass


func _on_DigitalNumberScreen4_on_drop():
	print("on_drop")
	var new_position : Vector2 = self.position
	self.position.x = round((self.position.x - (self.GridSize + self.ShiftPosition.x) / 2.0) / self.GridSize) * self.GridSize + self.ShiftPosition.x
	self.position.y = round((self.position.y - (self.GridSize + self.ShiftPosition.y) / 2.0) / self.GridSize) * self.GridSize + self.ShiftPosition.y
	pass
