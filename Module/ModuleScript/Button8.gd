extends Module

var ButtonList : Array = []
var InputPinList : Array = []
var LEDList : Array = []

func Init() -> void:
	self.Inited = true
	ButtonList.resize(8)
	ButtonList[0] = $Button8BG/SingleButton1
	ButtonList[1] = $Button8BG/SingleButton2
	ButtonList[2] = $Button8BG/SingleButton3
	ButtonList[3] = $Button8BG/SingleButton4
	ButtonList[4] = $Button8BG/SingleButton5
	ButtonList[5] = $Button8BG/SingleButton6
	ButtonList[6] = $Button8BG/SingleButton7
	ButtonList[7] = $Button8BG/SingleButton8
	InputPinList.resize(8)
	InputPinList[0] = $Pin1
	InputPinList[1] = $Pin2
	InputPinList[2] = $Pin3
	InputPinList[3] = $Pin4
	InputPinList[4] = $Pin5
	InputPinList[5] = $Pin6
	InputPinList[6] = $Pin7
	InputPinList[7] = $Pin8
	LEDList.resize(8)
	LEDList[0] = $Button8BG/SingleLED1
	LEDList[1] = $Button8BG/SingleLED2
	LEDList[2] = $Button8BG/SingleLED3
	LEDList[3] = $Button8BG/SingleLED4
	LEDList[4] = $Button8BG/SingleLED5
	LEDList[5] = $Button8BG/SingleLED6
	LEDList[6] = $Button8BG/SingleLED7
	LEDList[7] = $Button8BG/SingleLED8

func Update() -> void:
	var bitlist : Array = []
	bitlist.resize(8)
	for idx in range(0, InputPinList.size()) :
		(InputPinList[idx] as Pin).set_Data(ButtonList[idx].get_State())
		bitlist[idx] = ButtonList[idx].get_State()
	
	$Pin_Bus.set_Data(GlobalData.bin2dec(bitlist))
	
	pass

func _on_SingleButton_button_Clicked(state : bool, idx : int):
	LEDList[idx].set_LED(state)
	pass
	
func save_Module() -> Dictionary:
	var bitlist : Array = []
	bitlist.resize(8)
	for idx in range(0, InputPinList.size()) :
		bitlist[idx] = ButtonList[idx].get_State()
	return {"SaveID": self.SaveID, "Module": "Button8", "Position": [self.position.x, self.position.y], "SaveData": {"ButtonStateList": bitlist}}
	
func load_Module(data : Dictionary) -> void:
	if data.has("ButtonStateList") :
		var bitlist : Array = data["ButtonStateList"]
#		print(bitlist)
		for idx in range(0, bitlist.size()) :
			var ButtonState : bool = bitlist[idx]
			ButtonList[idx].set_Button(ButtonState)
			LEDList[idx].set_LED(ButtonState)
	pass