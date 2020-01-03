extends Module

func Update() -> void:
	$Pin1.set_Data($Button8BG/SingleButton1.get_State())
	$Pin2.set_Data($Button8BG/SingleButton2.get_State())
	$Pin3.set_Data($Button8BG/SingleButton3.get_State())
	$Pin4.set_Data($Button8BG/SingleButton4.get_State())
	$Pin5.set_Data($Button8BG/SingleButton5.get_State())
	$Pin6.set_Data($Button8BG/SingleButton6.get_State())
	$Pin7.set_Data($Button8BG/SingleButton7.get_State())
	$Pin8.set_Data($Button8BG/SingleButton8.get_State())
	pass

func _on_SingleButton1_button_Clicked(state):
	$Button8BG/SingleLED1.set_LED(state)
	pass # Replace with function body.


func _on_SingleButton2_button_Clicked(state):
	$Button8BG/SingleLED2.set_LED(state)
	pass # Replace with function body.


func _on_SingleButton3_button_Clicked(state):
	$Button8BG/SingleLED3.set_LED(state)
	pass # Replace with function body.


func _on_SingleButton4_button_Clicked(state):
	$Button8BG/SingleLED4.set_LED(state)
	pass # Replace with function body.


func _on_SingleButton5_button_Clicked(state):
	$Button8BG/SingleLED5.set_LED(state)
	pass # Replace with function body.


func _on_SingleButton6_button_Clicked(state):
	$Button8BG/SingleLED6.set_LED(state)
	pass # Replace with function body.


func _on_SingleButton7_button_Clicked(state):
	$Button8BG/SingleLED7.set_LED(state)
	pass # Replace with function body.


func _on_SingleButton8_button_Clicked(state):
	$Button8BG/SingleLED8.set_LED(state)
	pass # Replace with function body.
