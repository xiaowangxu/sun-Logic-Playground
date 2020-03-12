extends Line2D

var target : Pin = null

var AnchorPoint = preload("res://Connection/AnchorPoint.tscn")

func _ready():
	set_process(false)
	set_physics_process(false)
	
func start_Edit() -> void:
	for index in range(0, self.get_point_count()-1) :
		var addpoint = AnchorPoint.instance()
		addpoint.frame = 1
		addpoint.DragEnable = false
		addpoint.Index = index + 1
		addpoint.position = (get_point_position(index) + get_point_position(index + 1)) / 2
		addpoint.connect("on_doubleclick", self, "add_Point")
		self.add_child(addpoint)
	if self.get_point_count() > 2 :
		for index in range(1, self.get_point_count()-1) :
#			print(self.get_point_position(index))
			var movepoint = AnchorPoint.instance()
			movepoint.frame = 0
			movepoint.Index = index
			movepoint.position = get_point_position(index)
			movepoint.connect("is_dragging", self, "move_Point")
			movepoint.connect("on_doubleclick", self, "delete_Point")
			movepoint.connect("on_drop", self, "on_Drop")
			self.add_child(movepoint)
			
func exit_Edit() -> void:
	for point in self.get_children() :
		self.remove_child(point)
		point.queue_free()
	pass

func add_Point(point) -> void:
#	print(">> double click")
	var updated_list = points
	updated_list.insert(point.Index, point.position)
	self.points = updated_list
	self.exit_Edit()
	self.start_Edit()

func delete_Point(point) -> void:
#	print(">> double click")
	var updated_list = points
	updated_list.remove(point.Index)
	self.points = updated_list
	self.exit_Edit()
	self.start_Edit()
	
func move_Point(point) -> void:
	var new_position : Vector2 = Vector2.ZERO
	new_position.x = round(point.position.x / GlobalData.GridSize) * GlobalData.GridSize
	new_position.y = round(point.position.y / GlobalData.GridSize) * GlobalData.GridSize
	self.set_point_position(point.Index, new_position)
	for point in self.get_children() :
		if point.frame == 1 :
			self.remove_child(point)
			point.queue_free()
	for index in range(0, self.get_point_count()-1) :
		var addpoint = AnchorPoint.instance()
		addpoint.frame = 1
		addpoint.DragEnable = false
		addpoint.Index = index + 1
		addpoint.position = (get_point_position(index) + get_point_position(index + 1)) / 2
		addpoint.connect("on_doubleclick", self, "add_Point")
		self.add_child(addpoint)
	pass
	
func on_Drop(point) -> void:
	var new_position : Vector2 = Vector2.ZERO
	new_position.x = round(point.position.x / GlobalData.GridSize) * GlobalData.GridSize
	new_position.y = round(point.position.y / GlobalData.GridSize) * GlobalData.GridSize
	self.set_point_position(point.Index, new_position)
	self.exit_Edit()
	self.start_Edit()
	pass
