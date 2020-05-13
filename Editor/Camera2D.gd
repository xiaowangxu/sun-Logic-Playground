extends Camera2D

var LastPosition : Vector2 = Vector2.ZERO
var IsDragging : bool = false
export(float) var ZoomMin : float = 2
export(float) var ZoomMax : float = 0.5
export(float) var ZoomStep : float = 0.1
export(float) var ZoomDuration : float = 0.1
var ZoomTarget : float = 1.0

signal on_drag
signal is_dragging
signal on_drop
signal on_mouseleft_clicked
signal on_mouseright_clicked

func _ready():
	set_physics_process(false)
	set_process(false)
	pass

func tween_CameraZoom(zoom : Vector2) -> void:
	GlobalData.CameraZoom = zoom.x
	self.zoom = zoom
	pass

func zoom_In() -> void:
	self.ZoomTarget = self.ZoomMax if self.ZoomTarget - self.ZoomStep <= self.ZoomMax else self.ZoomTarget - self.ZoomStep
	var zoom : Vector2 = Vector2(self.ZoomTarget, self.ZoomTarget)
	$Tween.stop_all()
	$Tween.interpolate_method(self, "tween_CameraZoom", self.zoom, zoom, self.ZoomDuration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	pass
	
func zoom_Out() -> void:
	self.ZoomTarget = self.ZoomMin if self.ZoomTarget + self.ZoomStep >= self.ZoomMin else self.ZoomTarget + self.ZoomStep
	var zoom : Vector2 = Vector2(self.ZoomTarget, self.ZoomTarget)
	$Tween.stop_all()
	$Tween.interpolate_method(self, "tween_CameraZoom", self.zoom, zoom, self.ZoomDuration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	pass

func drop() -> void:
	self.LastPosition = Vector2.ZERO
	self.IsDragging = false
	pass

func _unhandled_input(event):
	if event.is_action_pressed("mousewheel_up") :
		self.zoom_In()
		
	if event.is_action_pressed("mousewheel_down") :
		self.zoom_Out()
	
	if event.is_action_pressed("mouse_left") :
		self.emit_signal("on_mouseleft_clicked")
	
	if event.is_action_pressed("mouse_right") :
		self.emit_signal("on_mouseright_clicked")
	
	if event.is_action_pressed("mouse_middle") :
		get_tree().set_input_as_handled()
		self.LastPosition = event.position
		self.IsDragging = true
		self.emit_signal("on_drag")
	
	if not self.IsDragging :
		return
	
	if event.is_action_released("mouse_middle") : 
		self.LastPosition = Vector2.ZERO
		self.IsDragging = false
		self.emit_signal("on_drop")
		
	if self.IsDragging and event is InputEventMouseMotion :
		self.position -= (event.position - LastPosition) * self.zoom
		self.LastPosition = event.position
		self.emit_signal("is_dragging")
		
	pass
