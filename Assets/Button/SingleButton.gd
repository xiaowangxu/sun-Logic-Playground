extends AnimatedSprite

var button : bool = false

signal button_Clicked(state)

func get_State() -> bool:
	return button
	
func set_Button(val : bool) -> void:
	button = val
	self.frame = 1 if button else 0
	pass
	

func _on_TouchScreenButton_pressed():
	self.set_Button(!button)
	emit_signal("button_Clicked", button)
	pass
