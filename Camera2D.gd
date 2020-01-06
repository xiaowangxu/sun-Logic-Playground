extends Camera2D

var LastPosition : Vector2 = Vector2.ZERO
var IsDragging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_left") :
		position.x -= 100*delta
	if Input.is_action_pressed("ui_right") :
		position.x += 100*delta
	pass

func _input(event):
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