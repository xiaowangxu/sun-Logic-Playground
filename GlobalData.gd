extends Node

var CameraZoom : float = 1.0

var hasClickableObj : bool = false

var LineInstance = preload("res://Connection/Line.tscn")

var ModuleInstance : Dictionary = {"Counter": preload("res://Module/Counter.tscn"), "DigitalNumberScreen4": preload("res://Module/DigitalNumberScreen4.tscn")}

var ToolMode : String = "Move"

var GridSize : float = 8.0

var ConnectLineState : bool = false
var CurrentLine = null