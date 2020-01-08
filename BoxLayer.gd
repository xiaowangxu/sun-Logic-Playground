extends CanvasLayer

export(Array, NodePath) var BoxArray : Array

func hide_All() -> void :
	for boxnodepath in BoxArray :
		var box = get_node(boxnodepath)
		box.hide()
		pass