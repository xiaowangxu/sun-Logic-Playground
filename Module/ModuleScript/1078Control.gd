extends Module

var Count : int = 0
var State : String = "None"
var Instruction : int = 0
var Operation : int = 0
var Address : int = 0

const InstructionSet : Array = ["Blank", "Load_A", "Load_B", "Load_C", "Load_D", "Move_Ans", "Move_C", "Move_D", "Add", "Increase", "Decrease", "Save_Ans", "Jump", "Jump_Zero", "Undefined", "Halt"]

func Update() -> void:
	if Count % 8 == 0 :
		self.change_State()
	self.act_State()
	self.set_StateLED()
	Count += 1
	Count %= 8
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
			var address : Array = Array()
			op.resize(4)
			op[3] = instruction[3]
			op[2] = instruction[2]
			op[1] = instruction[1]
			op[0] = instruction[0]
			address.resize(8)
			address[7] = instruction[15]
			address[6] = instruction[14]
			address[5] = instruction[13]
			address[4] = instruction[12]
			address[3] = instruction[11]
			address[2] = instruction[10]
			address[1] = instruction[9]
			address[0] = instruction[8]
			self.Operation = GlobalData.bin2dec(op)
			self.Address = GlobalData.bin2dec(address)
#			print(InstructionSet[self.Operation], " ", self.Address)
			return
		"Execute" :
			self.State = "Add"
			return
		"Add" :
			self.State = "Fetch"
			return
		"Halt" :
			return
	pass

func act_State() -> void:
	match self.State :
		"Fetch" :
			$Pin_PC_Enable.set_Data(true)
			$Pin_PC_Read.set_Data(true)
			$Pin_PC_Increase.set_Data(false)
			self.set_InstructionMemory(true, false)
			self.set_Program(true, true)
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_Jump()
			self.set_DataMemory()
			self.set_ALU()
			return
		"Decode" :
			$Pin_PC_Enable.set_Data(false)
			$Pin_PC_Read.set_Data(false)
			$Pin_PC_Increase.set_Data(false)
			self.set_InstructionMemory()
			self.set_Program(true, false)
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_Jump()
			self.set_DataMemory()
			self.set_ALU()
			self.Instruction = $Pin_Decode.update_Data()
			return
		"Execute" :
			$Pin_PC_Enable.set_Data(false)
			$Pin_PC_Read.set_Data(false)
			$Pin_PC_Increase.set_Data(false)
			self.set_InstructionMemory()
			self.set_Program()
			self.act_Instruction()
			return
		"Add" :
			$Pin_PC_Enable.set_Data(true)
			$Pin_PC_Read.set_Data(false)
			$Pin_PC_Increase.set_Data(true)
			self.set_InstructionMemory()
			self.set_Program()
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_Jump()
			self.set_DataMemory()
			self.set_ALU()
			return
		"Halt" :
			$Pin_PC_Enable.set_Data(false)
			$Pin_PC_Read.set_Data(false)
			$Pin_PC_Increase.set_Data(false)
			self.set_InstructionMemory()
			self.set_Program()
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_Jump()
			self.set_DataMemory()
			self.set_ALU()
			return

func act_Instruction() -> void:
	match InstructionSet[self.Operation] :
		"Blank", "Undefined" :
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory()
			return
		"Load_A" :
			self.set_A(true, true)
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory(true, false, self.Address, 0)
			return
		"Load_B" :
			self.set_A()
			self.set_B(true, true)
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory(true, false, self.Address, 0)
			return
		"Load_C" :
			self.set_A()
			self.set_B()
			self.set_C(true, true)
			self.set_D()
			self.set_Ans()
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory(true, false, self.Address, 0)
			return
		"Load_D" :
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D(true, true)
			self.set_Ans()
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory(true, false, self.Address, 0)
			return
		"Move_Ans" :
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans(true, false)
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory(true, true, self.Address, 0)
			return
		"Move_C" :
			self.set_A()
			self.set_B()
			self.set_C(true, false)
			self.set_D()
			self.set_Ans()
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory(true, true, self.Address, 0)
			return
		"Move_D" :
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D(true, false)
			self.set_Ans()
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory(true, true, self.Address, 0)
			return
		"Add" :
			self.set_A(true, false)
			self.set_B(true, false)
			self.set_C()
			self.set_D()
			self.set_Ans(true, true)
			self.set_ALU(1)
			self.set_Jump()
			self.set_DataMemory()
			return
		"Increase" :
			self.set_A(true, false)
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans(true, true)
			self.set_ALU(2)
			self.set_Jump()
			self.set_DataMemory()
			return
		"Decrease" :
			self.set_A(true, false)
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans(true, true)
			self.set_ALU(3)
			self.set_Jump()
			self.set_DataMemory()
			return
		"Save_Ans" :
			self.set_Ans(true, false)
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory()
			match self.Address :
				0 :
					self.set_A(true, true)
					self.set_B()
					self.set_C()
					self.set_D()
				1 :
					self.set_A()
					self.set_B(true, true)
					self.set_C()
					self.set_D()
				2 :
					self.set_A()
					self.set_B()
					self.set_C(true, true)
					self.set_D()
				3 :
					self.set_A()
					self.set_B()
					self.set_C()
					self.set_D(true, true)
			return
		"Jump_Zero" :
			self.set_A(true, false)
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_ALU(4)
			self.set_Jump(1)
			self.set_DataMemory()
			$Pin_PC_Enable.set_Data(true)
			$Pin_DataMemory_Address.set_Data(self.Address)
			return
		"Jump" :
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_ALU()
			self.set_Jump(2)
			self.set_DataMemory()
			$Pin_PC_Enable.set_Data(true)
			$Pin_DataMemory_Address.set_Data(self.Address)
			return
		"Halt" :
			self.set_A()
			self.set_B()
			self.set_C()
			self.set_D()
			self.set_Ans()
			self.set_ALU()
			self.set_Jump()
			self.set_DataMemory()
			self.State = "Halt"
			return
	pass

func set_Program(enable : bool = false, mode : bool = false) -> void:
	$Pin_Program_Enable.set_Data(enable)
	$Pin_Program_Mode.set_Data(mode)

func set_Jump(mode : int = 0) -> void:
	match mode :
		0 :
			$Pin_Jump.set_Data(false)
			$Pin_Jump_Zero.set_Data(false)
			return
		1 :
			$Pin_Jump.set_Data(false)
			$Pin_Jump_Zero.set_Data(true)
			return
		2 :
			$Pin_Jump.set_Data(true)
			$Pin_Jump_Zero.set_Data(false)
			return

func set_ALU(mode : int = 0) -> void:
	match mode :
		0 :
			$Pin_ALU_Enable.set_Data(false)
			$Pin_ALU1.set_Data(false)
			$Pin_ALU2.set_Data(false)
			return
		1 :
			$Pin_ALU_Enable.set_Data(true)
			$Pin_ALU1.set_Data(false)
			$Pin_ALU2.set_Data(false)
			return
		3 :
			$Pin_ALU_Enable.set_Data(true)
			$Pin_ALU1.set_Data(false)
			$Pin_ALU2.set_Data(true)
			return
		2 :
			$Pin_ALU_Enable.set_Data(true)
			$Pin_ALU1.set_Data(true)
			$Pin_ALU2.set_Data(false)
			return
		4 :
			$Pin_ALU_Enable.set_Data(true)
			$Pin_ALU1.set_Data(true)
			$Pin_ALU2.set_Data(true)
			return

func set_A(enable : bool = false, mode : bool = false) -> void:
	$Pin_A_Enable.set_Data(enable)
	$Pin_A_Mode.set_Data(mode)
	
func set_B(enable : bool = false, mode : bool = false) -> void:
	$Pin_B_Enable.set_Data(enable)
	$Pin_B_Mode.set_Data(mode)
	
func set_C(enable : bool = false, mode : bool = false) -> void:
	$Pin_C_Enable.set_Data(enable)
	$Pin_C_Mode.set_Data(mode)
	
func set_D(enable : bool = false, mode : bool = false) -> void:
	$Pin_D_Enable.set_Data(enable)
	$Pin_D_Mode.set_Data(mode)
	
func set_Ans(enable : bool = false, mode : bool = false) -> void:
	$Pin_Ans_Enable.set_Data(enable)
	$Pin_Ans_Mode.set_Data(mode)

func set_InstructionMemory(enable : bool = false, mode : bool = false) -> void:
	$Pin_InstructionMemory_Enable.set_Data(enable)
	$Pin_InstructionMemory_Mode.set_Data(mode)

func set_DataMemory(enable : bool = false, mode : bool = false, address : int = 0, data : int = 0) -> void:
	$Pin_DataMemory_Enable.set_Data(enable)
	$Pin_DataMemory_Mode.set_Data(mode)
	$Pin_DataMemory_Address.set_Data(address)

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
		"Halt" :
			$"1078ControlBG/SingleLED1".set_LED(true)
			$"1078ControlBG/SingleLED2".set_LED(true)
			$"1078ControlBG/SingleLED3".set_LED(true)
			$"1078ControlBG/SingleLED4".set_LED(true)
			return
	pass

func reset() -> void:
	self.Count = 0
	self.State = "None"

func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "1078Control", "Position": [self.position.x, self.position.y], "SaveData": {}}