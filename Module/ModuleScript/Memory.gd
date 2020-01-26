extends Module

var Enable : bool = false
var Data : PoolIntArray = PoolIntArray()
var AddressLEDList : Array = []
var DataLEDList : Array = []

func Init() -> void:
	self.Inited = true
	Data.resize(256)
	for idx in range(0, 256) :
		Data[idx] = idx
	AddressLEDList.resize(8)
	AddressLEDList[0] = $MemoryBG/SingleLED1
	AddressLEDList[1] = $MemoryBG/SingleLED2
	AddressLEDList[2] = $MemoryBG/SingleLED3
	AddressLEDList[3] = $MemoryBG/SingleLED4
	AddressLEDList[4] = $MemoryBG/SingleLED5
	AddressLEDList[5] = $MemoryBG/SingleLED6
	AddressLEDList[6] = $MemoryBG/SingleLED7
	AddressLEDList[7] = $MemoryBG/SingleLED8
	DataLEDList.resize(16)
	DataLEDList[0] = $MemoryBG/SingleLED9
	DataLEDList[1] = $MemoryBG/SingleLED10
	DataLEDList[2] = $MemoryBG/SingleLED11
	DataLEDList[3] = $MemoryBG/SingleLED12
	DataLEDList[4] = $MemoryBG/SingleLED13
	DataLEDList[5] = $MemoryBG/SingleLED14
	DataLEDList[6] = $MemoryBG/SingleLED15
	DataLEDList[7] = $MemoryBG/SingleLED16
	DataLEDList[8] = $MemoryBG/SingleLED17
	DataLEDList[9] = $MemoryBG/SingleLED18
	DataLEDList[10] = $MemoryBG/SingleLED19
	DataLEDList[11] = $MemoryBG/SingleLED20
	DataLEDList[12] = $MemoryBG/SingleLED21
	DataLEDList[13] = $MemoryBG/SingleLED22
	DataLEDList[14] = $MemoryBG/SingleLED23
	DataLEDList[15] = $MemoryBG/SingleLED24
	pass

func Update() -> void:
	Enable = $PinEnable.update_Data()
	$MemoryBG/SingleLEDEnable.set_LED(Enable)
	var data : int = $PinWrite.update_Data()
	var address : int = clamp($PinAddress.update_Data(), 0, 255) 
	if Enable :
		var Mode : bool = $PinMode.update_Data()
		if Mode :
#			Data = $PinWrite.update_Data()
			self.set_AddressLED(GlobalData.dec2bin(address, 8))
			self.set_DataLED(GlobalData.dec2bin(data, 16))
			$MemoryBG/SingleLEDMode.set_LED(2)
			self.Data[address] = data
		else :
#			$PinRead.set_Data(Data)
			self.set_AddressLED(GlobalData.dec2bin(address, 8))
			self.set_DataLED([false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false])
			$MemoryBG/SingleLEDMode.set_LED(1)
			$PinRead.set_Data(self.Data[address])
	else :
		self.set_AddressLED([false,false,false,false,false,false,false,false])
		self.set_DataLED([false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false])
		$PinRead.set_Data(0)
		$MemoryBG/SingleLEDMode.set_LED(0)
	pass

func set_AddressLED(state : Array) -> void:
	for idx in range(0, AddressLEDList.size()) :
		AddressLEDList[idx].set_LED(state[idx])
		
func set_DataLED(state : Array) -> void:
	for idx in range(0, DataLEDList.size()) :
		DataLEDList[idx].set_LED(state[idx])

func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Memory", "Position": [self.position.x, self.position.y], "SaveData": {"Data": self.Data}}
	
func load_Module(data : Dictionary) -> void:
	if data.has("Data") :
		Data = data["Data"]
#	print(Data)
	pass