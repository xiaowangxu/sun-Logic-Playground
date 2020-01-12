extends NinePatchRect

export(bool) var Pinned : bool = false
export(bool) var hasTab : bool = true
export(Vector2) var ShowPosition : Vector2 = Vector2(4,4)
export(Vector2) var HidePosition : Vector2 = Vector2(-300,4)
export(float) var Duration : float = 0.2
var IsShow : bool = false

signal on_show
signal on_hide

func _ready():
	set_process(false)
	set_physics_process(false)
	if not self.Pinned :
		self.rect_position = self.HidePosition
	pass

func is_Position_inside(position : Vector2) -> bool :
	if self.hasTab :
		return self.get_global_rect().has_point(position) or $Tab.get_global_rect().has_point(position)
	else :
		return self.get_global_rect().has_point(position)
	pass
	
func is_Area_inside(rect2 : Rect2) -> bool:
	if self.hasTab :
		return self.get_global_rect().encloses(rect2) or $Tab.get_global_rect().encloses(rect2)
	else :
		return self.get_global_rect().encloses(rect2)
	pass

func show() -> void:
	if self.IsShow or self.Pinned :
		return
	$Tween.stop_all()
	$Tween.interpolate_property(self, "rect_position", self.rect_position, Vector2(self.ShowPosition.x, self.rect_position.y), Duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	self.IsShow = true
	pass
	
func hide() -> void:
	if not self.IsShow or self.Pinned :
		return
	$Tween.stop_all()
	$Tween.interpolate_property(self, "rect_position", self.rect_position, Vector2(self.HidePosition.x, self.rect_position.y), Duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	self.IsShow = false
	pass

func _on_Button_pressed():
	if self.Pinned :
		return

	if self.IsShow :
		self.hide()
	else :
		self.emit_signal("on_show")
		self.show()
	pass
