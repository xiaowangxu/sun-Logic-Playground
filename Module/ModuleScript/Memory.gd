extends Module

var ButtonList : Array = []
var InputPinList : Array = []
var LEDList : Array = []

func Init() -> void:
	
	pass

func Update() -> void:
	
	pass

func _on_SingleButton_button_Clicked(state : bool, idx : int):
	
	pass
	
func save_Module() -> Dictionary:
	return {"SaveID": self.SaveID, "Module": "Memory", "Position": [self.position.x, self.position.y], "SaveData": {}}
	
func load_Module(data : Dictionary) -> void:
	pass