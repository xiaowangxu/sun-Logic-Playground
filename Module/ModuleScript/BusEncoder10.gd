extends Module

var LEDList : Array = []
var InputPinList : Array = []

func Init() -> void:
	self.Inited = true
	LEDList.resize(10)
	LEDList[0] = $BusEncoder10BG/SingleLED1
	LEDList[1] = $BusEncoder10BG/SingleLED2
	LEDList[2] = $BusEncoder10BG/SingleLED3
	LEDList[3] = $BusEncoder10BG/SingleLED4
	LEDList[4] = $BusEncoder10BG/SingleLED5
	LEDList[5] = $BusEncoder10BG/SingleLED6
	LEDList[6] = $BusEncoder10BG/SingleLED7
	LEDList[7] = $BusEncoder10BG/SingleLED8
	LEDList[8] = $BusEncoder10BG/SingleLED9
	LEDList[9] = $BusEncoder10BG/SingleLED10
	InputPinList.resize(10)
	InputPinList[0] = $Pin1
	InputPinList[1] = $Pin2
	InputPinList[2] = $Pin3
	InputPinList[3] = $Pin4
	InputPinList[4] = $Pin5
	InputPinList[5] = $Pin6
	InputPinList[6] = $Pin7
	InputPinList[7] = $Pin8
	InputPinList[8] = $Pin9
	InputPinList[9] = $Pin10

func Update() -> void:
	var bitlist : Array = []
	bitlist.resize(10)
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
	return {"SaveID": self.SaveID, "Module": "BusEncoder10", "Position": [self.position.x, self.position.y], "SaveData": {}}
