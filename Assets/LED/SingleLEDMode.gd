extends AnimatedSprite

enum Mode {NONE, READ, WRITE}

func set_LED(mode : int) -> void:
	match mode :
		Mode.NONE :
			self.frame = 0
		Mode.READ :
			self.frame = 1
		Mode.WRITE :
			self.frame = 2
	pass
