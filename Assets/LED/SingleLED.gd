extends AnimatedSprite

func set_LED(val : bool) -> void:
	self.frame = 1 if val else 0
	pass
