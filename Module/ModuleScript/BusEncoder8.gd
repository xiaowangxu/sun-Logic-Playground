extends Module

var LEDList : Array = []
var InputPinList : Array = []

func Init() -> void:
	self.Inited = true
	LEDList.resize(8)
	LEDList[0] = $BusEncoder8BG/SingleLED1
	LEDList[1] = $BusEncoder8BG/SingleLED2
	LEDList[2] = $BusEncoder8BG/SingleLED3
	LEDList[3] = $BusEncoder8BG/SingleLED4
	LEDList[4] = $BusEncoder8BG/SingleLED5
	LEDList[5] = $BusEncoder8BG/SingleLED6
	LEDList[6] = $BusEncoder8BG/SingleLED7
	LEDList[7] = $BusEncoder8BG/SingleLED8
	InputPinList.resize(8)
	InputPinList[0] = $Pin1
	InputPinList[1] = $Pin2
	InputPinList[2] = $Pin3
	InputPinList[3] = $Pin4
	InputPinList[4] = $Pin5
	InputPinList[5] = $Pin6
	InputPinList[6] = $Pin7
	InputPinList[7] = $Pin8

func Update() -> void:
	var bitlist : Array = []
	bitlist.resize(8)
	for idx in range(0, InputPinList.size()) :
		var data : bool = InputPinList[idx].update_Data()
		LEDList[idx].set_LED(data)
		bitlist[idx] = data
	$Pin_Bus.set_Data(GlobalData.bin2dec(bitlist))
	pass

func _on_SingleButton_button_Clicked(state : bool, idx : int):
	LEDList[idx].set_LED(state)
	pass
	
func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "BusEncoder8", "Position": [self.position.x, self.position.y], "SaveData": {}}
