extends Module

func Update() -> void:
	var mode : int = GlobalData.bin2dec([$PinMode2.update_Data(), $PinMode1.update_Data()])
	var enable : bool = $PinEnable.update_Data()
	var a : int = clamp($PinA.update_Data(), 0, INF)
	var w : int = clamp($PinW.update_Data(), 0, INF)
	var ans : int = 0
	if enable :
		match mode :
			0 :
				ans = clamp(a+w, 0, INF)
				$PinD.set_Data(ans)
			1 :
				ans = clamp(a+1, 0, INF)
				$PinD.set_Data(ans)
			2 :
				ans = clamp(a-1, 0, INF)
				$PinD.set_Data(ans)
			_ :
				ans = clamp(a  , 0, INF)
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
	