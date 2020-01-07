extends NinePatchRect

export(Vector2) var ShowPosition : Vector2 = Vector2(4,4)
export(Vector2) var HidePosition : Vector2 = Vector2(-300,4)
export(float) var Duration : float = 0.2
var IsShow : bool = false

func _ready():
	set_process(false)
	set_physics_process(false)
	self.rect_position = self.HidePosition
	pass

func show() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property(self, "rect_position", self.rect_position, self.ShowPosition, Duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	self.IsShow = true
	pass
	
func hide() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property(self, "rect_position", self.rect_position, self.HidePosition, Duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	self.IsShow = false
	pass

func _on_Button_pressed():
	if self.IsShow :
		self.hide()
	else :
		self.show()
	pass # Replace with function body.
