extends Module

func Update() -> void:
	var mode : int = GlobalData.bin2dec([$PinMode2.update_Data(), $PinMode1.update_Data()])
	var enable : bool = $PinEnable.update_Data()
	var a : int = $PinA.update_Data()
	var w : int = $PinW.update_Data()
	var ans : int = 0
	if enable :
		match mode :
			0 :
				ans = a+w
				$PinD.set_Data(ans)
			1 :
				ans = a+1
				$PinD.set_Data(ans)
			2 :
				ans = a-1
				$PinD.set_Data(ans)
			_ :
				ans = a
				$PinD.set_Data(ans)
		if ans == 0 :
			$PinZero.set_Data(true)
		else :
			$PinZero.set_Data(false)
	else :
		$PinD.set_Data(0)
		$PinZero.set_Data(false)
	pass
	
func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "ALU", "Position": [self.position.x, self.position.y], "SaveData": {}}