extends AnimatedSprite2D

var enteredAreas = [];
func _on_light_beam_entered_light():
	self.set_frame(1)


func _on_light_beam_left_light():
	self.set_frame(0)

