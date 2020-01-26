extends Module

var Count : int = 0
var State : String = "None"
var Instruction : int = 0
var Operation : int = 0

const InstructionSet : Array = ["Blank", "Load_A", "Load_B", "Load_C", "Load_D", "Move_Ans", "Move_C", "Move_D", "Add", "Increase", "Decrease", "Save_Ans", "Jump", "Jump_Zero", "Undefined", "Halt"]

func Update() -> void:
	if Count % 20 == 0 :
		self.change_State()
	self.act_State()
	self.set_StateLED()
	Count += 1
	Count %= 20
	pass

func change_State() -> void:
	match self.State :
		"None" :
			self.State = "Fetch"
			return
		"Fetch" :
			self.State = "Decode"
			return
		"Decode" :
			self.State = "Execute"
#			print(self.Instruction)
			var instruction : Array = GlobalData.dec2bin(self.Instruction, 16)
			var op : Array = Array()
			op.resize(4)
			op[3] = instruction[3]
			op[2] = instruction[2]
			op[1] = instruction[1]
			op[0] = instruction[0]
			self.Operation = GlobalData.bin2dec(op)
			print(InstructionSet[self.Operation])
			return
		"Execute" :
			self.State = "Add"
			return
		"Add" :
			self.State = "Fetch"
			return
	pass

func act_State() -> void:
	match self.State :
		"Fetch" :
			$Pin_PC_Enable.set_Data(true)
			$Pin_PC_Read.set_Data(true)
			$Pin_PC_Increase.set_Data(false)
			$Pin_Memory_Enable.set_Data(true)
			$Pin_Memory_Mode.set_Data(false)
			$Pin_Program_Enable.set_Data(true)
			$Pin_Program_Mode.set_Data(true)
			return
		"Decode" :
			$Pin_PC_Enable.set_Data(false)
			$Pin_PC_Read.set_Data(false)
			$Pin_PC_Increase.set_Data(false)
			$Pin_Memory_Enable.set_Data(false)
			$Pin_Memory_Mode.set_Data(false)
			$Pin_Program_Enable.set_Data(true)
			$Pin_Program_Mode.set_Data(false)
			self.Instruction = $Pin_Decode.update_Data()
			return
		"Execute" :
			return
		"Add" :
			$Pin_PC_Enable.set_Data(true)
			$Pin_PC_Read.set_Data(false)
			$Pin_PC_Increase.set_Data(true)
			$Pin_Memory_Enable.set_Data(false)
			$Pin_Memory_Mode.set_Data(false)
			$Pin_Program_Enable.set_Data(false)
			$Pin_Program_Mode.set_Data(false)
			return

func set_StateLED() -> void:
	match self.State :
		"None" :
			$"1078ControlBG/SingleLED1".set_LED(false)
			$"1078ControlBG/SingleLED2".set_LED(false)
			$"1078ControlBG/SingleLED3".set_LED(false)
			$"1078ControlBG/SingleLED4".set_LED(false)
			return
		"Fetch" :
			$"1078ControlBG/SingleLED1".set_LED(true)
			$"1078ControlBG/SingleLED2".set_LED(false)
			$"1078ControlBG/SingleLED3".set_LED(false)
			$"1078ControlBG/SingleLED4".set_LED(false)
			return
		"Decode" :
			$"1078ControlBG/SingleLED1".set_LED(false)
			$"1078ControlBG/SingleLED2".set_LED(true)
			$"1078ControlBG/SingleLED3".set_LED(false)
			$"1078ControlBG/SingleLED4".set_LED(false)
			return
		"Execute" :
			$"1078ControlBG/SingleLED1".set_LED(false)
			$"1078ControlBG/SingleLED2".set_LED(false)
			$"1078ControlBG/SingleLED3".set_LED(true)
			$"1078ControlBG/SingleLED4".set_LED(false)
			return
		"Add" :
			$"1078ControlBG/SingleLED1".set_LED(false)
			$"1078ControlBG/SingleLED2".set_LED(false)
			$"1078ControlBG/SingleLED3".set_LED(false)
			$"1078ControlBG/SingleLED4".set_LED(true)
			return
	pass

func reset() -> void:
	self.Count = 0
	self.State = "None"

func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "1078Control", "Position": [self.position.x, self.position.y], "SaveData": {}}