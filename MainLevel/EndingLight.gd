extends PointLight2D

@export var treeSprite: AnimatedSprite2D
func _on_big_shroom_finish_game():
	var tween = create_tween()
	tween.tween_property(self, "energy", 400, 2).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(reverse.bind())
	
	

func reverse():
	var tween = create_tween()	
	treeSprite.set_frame(0)
	tween.tween_property(self, "energy", 0, 3).set_trans(Tween.TRANS_SINE)
	
