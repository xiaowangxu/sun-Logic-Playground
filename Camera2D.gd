extends Camera2D

var LastPosition : Vector2 = Vector2.ZERO
var IsDragging : bool = false
export(float) var ZoomMin : float = 2
export(float) var ZoomMax : float = 0.5
export(float) var ZoomStep : float = 0.1
export(float) var ZoomDuration : float = 0.1
var ZoomTarget : float = 1.0

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
	$Tween.interpolate_method(self, "tween_CameraZoom", self.zoom, zoom, self.ZoomDuration, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	pass
	
func zoom_Out() -> void:
	self.ZoomTarget = self.ZoomMin if self.ZoomTarget + self.ZoomStep >= self.ZoomMin else self.ZoomTarget + self.ZoomStep
	var zoom : Vector2 = Vector2(self.ZoomTarget, self.ZoomTarget)
	$Tween.stop_all()
	$Tween.interpolate_method(self, "tween_CameraZoom", self.zoom, zoom, self.ZoomDuration, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
	pass

func _input(event):
	if event.is_action_pressed("mousewheel_up") :
		self.zoom_In()
		
	if event.is_action_pressed("mousewheel_down") :
		self.zoom_Out()
	
	if event.is_action_pressed("mouse_middle") :
		get_tree().set_input_as_handled()
		self.LastPosition = event.position
		self.IsDragging = true
	
	if not self.IsDragging :
		return
	
	if event.is_action_released("mouse_middle") : 
		self.LastPosition = Vector2.ZERO
		self.IsDragging = false
		
	if self.IsDragging and event is InputEventMouseMotion:
		self.position -= (event.position - LastPosition) * self.zoom
		self.LastPosition = event.position
		
	pass